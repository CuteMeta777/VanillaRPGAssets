#> enchantplus:debug/give_all_7_max
#
# @description 커스텀 인챈트북 7번 묶음을 최대 레벨로 지급합니다.
#

give @s minecraft:enchanted_book[minecraft:stored_enchantments={"enchantplus:tools/auto_smelt":1}]
give @s minecraft:enchanted_book[minecraft:stored_enchantments={"enchantplus:tools/miningplus":1}]
give @s minecraft:enchanted_book[minecraft:stored_enchantments={"enchantplus:trident/gungnir_breath":3}]

tellraw @s [{"text":"[NeoEnchant+] 디버그 인챈트북 7/7 지급 완료 ","color":"gold"},{"text":"(최대 레벨, 3개)","color":"yellow"}]
tellraw @s [{"text":"- ","color":"gray"},{"translate":"enchantment.enchantplus.auto_smelt","fallback":"Auto Smelt","color":"aqua"},{"text":" (레벨 1)","color":"gray"},{"text":"\n  효과: ","color":"dark_gray"},{"translate":"enchantment.enchantplus.tools/auto_smelt.desc","fallback":"Automatically smelts mined items.","color":"white"},{"text":"\n  설명: ","color":"dark_gray"},{"translate":"advancement.enchantplus.description.auto_smelt","fallback":"The best enchantment ever !","color":"white"}]
tellraw @s [{"text":"- ","color":"gray"},{"translate":"enchantment.enchantplus.miningplus","fallback":"Mining+","color":"aqua"},{"text":" (레벨 1)","color":"gray"},{"text":"\n  효과: ","color":"dark_gray"},{"translate":"enchantment.enchantplus.tools/miningplus.desc","fallback":"Mines in a 3x3 area.","color":"white"},{"text":"\n  설명: ","color":"dark_gray"},{"translate":"advancement.enchantplus.description.miningplus","fallback":"Welcome to paladium !","color":"white"}]
tellraw @s [{"text":"- ","color":"gray"},{"translate":"enchantment.enchantplus.gungnir_breath","fallback":"Gungnir Breath","color":"aqua"},{"text":" (레벨 3)","color":"gray"},{"text":"\n  효과: ","color":"dark_gray"},{"translate":"enchantment.enchantplus.trident/gungnir_breath.desc","fallback":"Freezes water and slows targets.","color":"white"},{"text":"\n  설명: ","color":"dark_gray"},{"translate":"advancement.enchantplus.description.gungnir_breath","fallback":"Odin's favorite weapon","color":"white"}]
