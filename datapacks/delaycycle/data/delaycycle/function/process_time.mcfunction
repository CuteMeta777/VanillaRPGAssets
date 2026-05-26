# 월드 시간을 1틱 진행시킵니다.
execute in minecraft:overworld run time add 1
execute in minecraft:nether run time add 1
execute in minecraft:end run time add 1

# 버퍼에서 10을 깎습니다.
scoreboard players remove #buffer dc_vars 10

# rate가 20, 30같이 높을 경우를 대비해, 버퍼가 아직도 10 이상이라면 한 번 더 반복 실행합니다.
execute if score #buffer dc_vars matches 10.. run function delaycycle:process_time