# 1. 현재 자고 있는 플레이어 수를 측정합니다.
execute store result score #sleeping dc_vars if entity @a[predicate=delaycycle:is_sleeping]

# 2. 누군가 막 침대에 누웠을 때 (바닐라 사이클 켜서 아침으로 넘어가게 유도)
execute if score #sleeping dc_vars matches 1.. if score #was_sleeping dc_vars matches 0 run gamerule advance_time true

# 3. 아침이 되어 모두가 일어났을 때 (바닐라 사이클 다시 끄기)
execute if score #sleeping dc_vars matches 0 if score #was_sleeping dc_vars matches 1.. run gamerule advance_time false

# 4. 이전 수면 상태를 현재 상태로 업데이트합니다.
scoreboard players operation #was_sleeping dc_vars = #sleeping dc_vars

# 5. 자는 사람이 없을 때만 우리가 만든 커스텀 타임사이클을 돌립니다.
execute if score #sleeping dc_vars matches 0 run scoreboard players operation #buffer dc_vars += #rate dc_vars
execute if score #sleeping dc_vars matches 0 if score #buffer dc_vars matches 10.. run function delaycycle:process_time