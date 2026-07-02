import os
import re
import json
import shutil

src_dir = r"c:\Users\eigen\Desktop\VanillaRPG\src\main\java\cutemeta\item"
base_assets_dir = r"c:\Users\eigen\Desktop\VanillaRPGAssets\resourcepacks\CuteMetaResourcePack\assets\minecraft"
items_dir = os.path.join(base_assets_dir, "items")
models_item_dir = os.path.join(base_assets_dir, "models", "item")

files = [
    "MaterialRegistry.java",
    "ArmorRegistry.java",
    "WeaponRegistry.java",
    "AccessoryRegistry.java",
    "UtilityRegistry.java",
    "EnhancerRegistry.java",
    "WarpScrollRegistry.java"
]

counters = {
    "ACCESSORY": 1000,
    "MATERIAL": 2000,
    "WEAPON": 3000,
    "UTILITY": 4000,
    "ARMOR": 7000,
    "ENHANCER": 6000,
    "TOOL": 8000,
}

items = []

for f in files:
    path = os.path.join(src_dir, f)
    if not os.path.exists(path):
        continue
    with open(path, 'r', encoding='utf-8') as f_in:
        content = f_in.read()
        # Split by register calls
        parts = content.split("CustomItemRegistryCore.register")
        for part in parts[1:]:
            # Extract basic info
            match = re.search(
                r'\s*\(\s*"([A-Z0-9_]+)"\s*,\s*"([a-z0-9_]+)"\s*,\s*"[^"]*"\s*,\s*Material\.(?:valueOf\("([^"]+)"\)|([A-Z0-9_]+))\s*,\s*CustomItemCategory\.([A-Z_]+)',
                part
            )
            if not match:
                continue
            
            enum_name = match.group(1)
            item_id = match.group(2)
            mat1 = match.group(3)
            mat2 = match.group(4)
            base_material = mat1 if mat1 else mat2
            category = match.group(5)
            
            # Extract subCategory if exists
            sub_match = re.search(r'subCategory\("([^"]+)"\)', part)
            sub_category = sub_match.group(1) if sub_match else "general"
            
            # Clean up names for folders
            cat_folder = category.lower()
            subcat_folder = sub_category.lower().replace(" ", "_").replace("&", "and").replace("'", "")
            
            model_id = counters.get(category, 0)
            counters[category] = model_id + 1
            
            items.append({
                "enum_name": enum_name,
                "item_id": item_id,
                "base_material": base_material.lower(),
                "category": category,
                "model_id": model_id,
                "folder_path": f"{cat_folder}/{subcat_folder}"
            })

# Cleanup Phase
print("Cleaning up old files...")
if os.path.exists(items_dir):
    shutil.rmtree(items_dir)
os.makedirs(items_dir)

if os.path.exists(models_item_dir):
    shutil.rmtree(models_item_dir)
os.makedirs(models_item_dir)

# Organize items by base material
base_overrides = {}

for item in items:
    if item["category"] == "ARMOR" or item["enum_name"].startswith("VANILLA_"):
        continue
    
    base_mat = item["base_material"]
    if base_mat not in base_overrides:
        base_overrides[base_mat] = []
        
    # Create the required subdirectories in models/item/
    target_folder = os.path.join(models_item_dir, item["folder_path"])
    os.makedirs(target_folder, exist_ok=True)
    
    model_path = f"item/{item['folder_path']}/{item['item_id']}"
    
    # 1. Generate the individual model JSON
    parent = "minecraft:item/generated"
    if item["category"] in ["WEAPON", "TOOL"]:
        parent = "minecraft:item/handheld"
        
    individual_model_data = {
        "parent": parent,
        "textures": {
            "layer0": f"minecraft:{model_path}"
        }
    }
    
    with open(os.path.join(target_folder, f"{item['item_id']}.json"), "w", encoding="utf-8") as f_out:
        json.dump(individual_model_data, f_out, indent=2)
        
    # 2. Add to base overrides
    base_overrides[base_mat].append({
        "threshold": item["model_id"],
        "model": {
            "type": "minecraft:model",
            "model": f"minecraft:{model_path}"
        }
    })

# 3. Generate the 1.21.2+ item dispatch JSONs
for base_mat, entries in base_overrides.items():
    entries.sort(key=lambda x: x["threshold"])
    
    dispatch_data = {
        "model": {
            "type": "minecraft:range_dispatch",
            "property": "minecraft:custom_model_data",
            "fallback": {
                "type": "minecraft:model",
                "model": f"minecraft:item/{base_mat}"
            },
            "entries": entries
        }
    }
    
    with open(os.path.join(items_dir, f"{base_mat}.json"), "w", encoding="utf-8") as f_out:
        json.dump(dispatch_data, f_out, indent=2)

print(f"Generated {sum(len(v) for v in base_overrides.values())} custom models in subfolders.")
print(f"Generated {len(base_overrides)} base material dispatch files in items/ directory.")
