# Process all remaining markers
execute in minecraft:overworld as @e[type=marker,tag=enchantplus.hit_block.miningplus] at @s if block ~ ~ ~ minecraft:air run function enchantplus:actions/miningplus/destroy
execute in minecraft:the_nether as @e[type=marker,tag=enchantplus.hit_block.miningplus] at @s if block ~ ~ ~ minecraft:air run function enchantplus:actions/miningplus/destroy
execute in minecraft:the_end as @e[type=marker,tag=enchantplus.hit_block.miningplus] at @s if block ~ ~ ~ minecraft:air run function enchantplus:actions/miningplus/destroy
execute in minecraft:cursed_world as @e[type=marker,tag=enchantplus.hit_block.miningplus] at @s if block ~ ~ ~ minecraft:air run function enchantplus:actions/miningplus/destroy
execute in minecraft:cursed_world_nether as @e[type=marker,tag=enchantplus.hit_block.miningplus] at @s if block ~ ~ ~ minecraft:air run function enchantplus:actions/miningplus/destroy
execute in minecraft:cursed_world_the_end as @e[type=marker,tag=enchantplus.hit_block.miningplus] at @s if block ~ ~ ~ minecraft:air run function enchantplus:actions/miningplus/destroy

# Schedule the next iteration if there are still markers to process
execute in minecraft:overworld if entity @e[type=marker,tag=enchantplus.hit_block.miningplus] run schedule function enchantplus:actions/miningplus/process_markers 1t
execute in minecraft:the_nether if entity @e[type=marker,tag=enchantplus.hit_block.miningplus] run schedule function enchantplus:actions/miningplus/process_markers 1t
execute in minecraft:the_end if entity @e[type=marker,tag=enchantplus.hit_block.miningplus] run schedule function enchantplus:actions/miningplus/process_markers 1t
execute in minecraft:cursed_world if entity @e[type=marker,tag=enchantplus.hit_block.miningplus] run schedule function enchantplus:actions/miningplus/process_markers 1t
execute in minecraft:cursed_world_nether if entity @e[type=marker,tag=enchantplus.hit_block.miningplus] run schedule function enchantplus:actions/miningplus/process_markers 1t
execute in minecraft:cursed_world_the_end if entity @e[type=marker,tag=enchantplus.hit_block.miningplus] run schedule function enchantplus:actions/miningplus/process_markers 1t