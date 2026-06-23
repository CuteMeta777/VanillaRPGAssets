$combat = "C:\Users\eigen\Desktop\VanillaRPGAssets\datapacks\vrpg_enchants_combat\data\vrpg\enchantment\sword"
$tools = "C:\Users\eigen\Desktop\VanillaRPGAssets\datapacks\vrpg_enchants_tools\data\vrpg\enchantment\tools"
$axe = "C:\Users\eigen\Desktop\VanillaRPGAssets\datapacks\vrpg_enchants_tools\data\vrpg\enchantment\axe"
$helmet = "C:\Users\eigen\Desktop\VanillaRPGAssets\datapacks\vrpg_enchants_armor\data\vrpg\enchantment\helmet"
$chest = "C:\Users\eigen\Desktop\VanillaRPGAssets\datapacks\vrpg_enchants_armor\data\vrpg\enchantment\chestplate"
$legs = "C:\Users\eigen\Desktop\VanillaRPGAssets\datapacks\vrpg_enchants_armor\data\vrpg\enchantment\leggings"

New-Item -ItemType Directory -Force -Path $combat
New-Item -ItemType Directory -Force -Path $tools
New-Item -ItemType Directory -Force -Path $axe
New-Item -ItemType Directory -Force -Path $helmet
New-Item -ItemType Directory -Force -Path $chest
New-Item -ItemType Directory -Force -Path $legs

function Write-Enchant {
    param($Path, $Name, $Fallback, $Items, $MaxLevel=5)
    $json = @"
{
  "description": {
    "translate": "enchantment.vrpg.$Name",
    "fallback": "$Fallback"
  },
  "supported_items": "$Items",
  "primary_items": "$Items",
  "weight": 2,
  "max_level": $MaxLevel,
  "min_cost": { "base": 10, "per_level_above_first": 5 },
  "max_cost": { "base": 60, "per_level_above_first": 5 },
  "anvil_cost": 4,
  "slots": ["mainhand", "head", "chest", "legs", "feet"]
}
"@
    Set-Content -Path $Path -Value $json -Encoding UTF8
}

Write-Enchant "$combat\xp_boost.json" "xp_boost" "XP Boost" "#minecraft:swords"
Write-Enchant "$axe\timber.json" "timber" "Timber" "#minecraft:axes" 1
Write-Enchant "$tools\miningplus.json" "miningplus" "Mining Plus" "#minecraft:mining_loot_enchantable"
Write-Enchant "$tools\auto_smelt.json" "auto_smelt" "Auto Smelt" "#minecraft:mining_loot_enchantable" 1
Write-Enchant "$helmet\voidless.json" "voidless" "Voidless" "#minecraft:head_armor" 1
Write-Enchant "$helmet\bright_vision.json" "bright_vision" "Bright Vision" "#minecraft:head_armor" 1
Write-Enchant "$chest\builder_arm.json" "builder_arm" "Builder's Arm" "#minecraft:chest_armor" 1
Write-Enchant "$legs\fast_swim.json" "fast_swim" "Fast Swim" "#minecraft:leg_armor"
Write-Enchant "$legs\dwarfed.json" "dwarfed" "Dwarfed" "#minecraft:leg_armor" 1
