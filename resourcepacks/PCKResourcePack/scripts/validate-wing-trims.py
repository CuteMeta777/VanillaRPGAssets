#!/usr/bin/env python3
import pathlib
import struct
import sys
import zlib


ROOT = pathlib.Path(__file__).resolve().parents[1]
WING_TRIMS = ROOT / "assets/minecraft/textures/trims/entity/wings"


def _samples(row, bit_depth, width):
    if bit_depth == 8:
        return list(row[:width])
    values = []
    for byte in row:
        for shift in range(8 - bit_depth, -1, -bit_depth):
            values.append((byte >> shift) & ((1 << bit_depth) - 1))
            if len(values) == width:
                return values
    return values


def read_png_rgba(path):
    data = path.read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError(f"{path}: not a PNG")

    pos = 8
    palette = []
    transparency = []
    idat = b""
    while pos < len(data):
        length = struct.unpack(">I", data[pos:pos + 4])[0]
        chunk_type = data[pos + 4:pos + 8]
        chunk = data[pos + 8:pos + 8 + length]
        pos += 12 + length

        if chunk_type == b"IHDR":
            width, height, bit_depth, color_type, _, _, interlace = struct.unpack(">IIBBBBB", chunk)
            if interlace:
                raise ValueError(f"{path}: interlaced PNGs are not supported")
        elif chunk_type == b"PLTE":
            palette = [tuple(chunk[i:i + 3]) for i in range(0, len(chunk), 3)]
        elif chunk_type == b"tRNS":
            transparency = list(chunk)
        elif chunk_type == b"IDAT":
            idat += chunk
        elif chunk_type == b"IEND":
            break

    if color_type in (0, 3) and bit_depth < 8:
        row_bytes = (width * bit_depth + 7) // 8
        filter_bpp = 1
    else:
        channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[color_type]
        row_bytes = width * channels * (bit_depth // 8)
        filter_bpp = max(1, channels * (bit_depth // 8))

    raw = zlib.decompress(idat)
    pixels = []
    prev = [0] * row_bytes
    offset = 0
    for _ in range(height):
        filter_type = raw[offset]
        offset += 1
        row = list(raw[offset:offset + row_bytes])
        offset += row_bytes
        recon = [0] * row_bytes

        for i, value in enumerate(row):
            left = recon[i - filter_bpp] if i >= filter_bpp else 0
            up = prev[i]
            up_left = prev[i - filter_bpp] if i >= filter_bpp else 0
            if filter_type == 0:
                recon[i] = value
            elif filter_type == 1:
                recon[i] = (value + left) & 255
            elif filter_type == 2:
                recon[i] = (value + up) & 255
            elif filter_type == 3:
                recon[i] = (value + ((left + up) // 2)) & 255
            elif filter_type == 4:
                estimate = left + up - up_left
                distances = (abs(estimate - left), abs(estimate - up), abs(estimate - up_left))
                predictor = left if distances[0] <= distances[1] and distances[0] <= distances[2] else up if distances[1] <= distances[2] else up_left
                recon[i] = (value + predictor) & 255
            else:
                raise ValueError(f"{path}: unsupported PNG filter {filter_type}")

        prev = recon
        if color_type == 0:
            for gray in _samples(recon, bit_depth, width):
                if bit_depth < 8:
                    gray = round(gray * 255 / ((1 << bit_depth) - 1))
                pixels.append((gray, gray, gray, 255))
        elif color_type == 2:
            for x in range(width):
                pixels.append(tuple(recon[x * 3:x * 3 + 3]) + (255,))
        elif color_type == 3:
            for index in _samples(recon, bit_depth, width):
                red, green, blue = palette[index]
                alpha = transparency[index] if index < len(transparency) else 255
                pixels.append((red, green, blue, alpha))
        elif color_type == 6:
            for x in range(width):
                pixels.append(tuple(recon[x * 4:x * 4 + 4]))
        else:
            raise ValueError(f"{path}: unsupported PNG color type {color_type}")

    return width, height, pixels


def validate():
    failures = []
    for path in sorted(WING_TRIMS.glob("*.png")):
        width, height, pixels = read_png_rgba(path)
        opaque = [pixel for pixel in pixels if pixel[3] > 0]
        opaque_black = [pixel for pixel in opaque if pixel[0] == 0 and pixel[1] == 0 and pixel[2] == 0]
        if (width, height) != (64, 32):
            failures.append(f"{path.name}: expected 64x32, got {width}x{height}")
        if len(opaque) > 512:
            failures.append(f"{path.name}: {len(opaque)} opaque pixels, likely missing transparent background")
        if opaque_black:
            failures.append(f"{path.name}: {len(opaque_black)} opaque black pixels, likely leaked trim background")

    if failures:
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1
    print(f"validated {len(list(WING_TRIMS.glob('*.png')))} wing trim textures")
    return 0


if __name__ == "__main__":
    raise SystemExit(validate())
