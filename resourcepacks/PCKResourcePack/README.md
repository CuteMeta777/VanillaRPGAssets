# PCKResourcePack

Additional resource pack for the CuteMeta VanillaRPG server.

This pack is intended to layer on top of the existing `CuteMeta777/MyServerResourcePack`
release pack. Keep changes small and avoid overriding existing asset paths unless a PR
explicitly documents the reason.

## Build

Create a release zip from the repository root:

```bash
./scripts/build-pack.sh
```

The script writes:

```text
build/assets.zip
build/assets.sha1
```

Upload `build/assets.zip` to a GitHub Release, then copy the release URL and SHA-1 into
the VanillaRPG plugin config under `resource-packs.additional.pck`.

## Handoff

When another chat changes this resource pack, it should report the change back to the
PM chat using:

```text
/Users/pck2790/Documents/CuteMeta_VanillaRPG_Project/documents/handoff/PM_COORDINATION.md
```

For art work, include the target item, changed files, texture size, animation settings,
preview path, art intent, release status, and any plugin-side model/config work still
needed.

Current local art note:

- `Starfier` has a local 4-frame animated item texture at
  `assets/minecraft/textures/item/starfier.png`.
- The pack also overrides `assets/minecraft/items/nether_star.json` so CustomModelData
  `6000` resolves to `minecraft:item/starfier`.
- Its review preview is `previews/item/starfier.gif`.
- The current PM handoff note records the art intent and remaining integration checks.
