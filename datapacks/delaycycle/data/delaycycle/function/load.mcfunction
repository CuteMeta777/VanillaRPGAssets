# 기본 낮/밤 주기 끄기
gamerule advance_time false
gamerule command_block_output false

# 변수 저장용 스코어보드 생성
scoreboard objectives add dc_vars dummy
scoreboard players set #buffer dc_vars 0
scoreboard players set #was_sleeping dc_vars 0
scoreboard players set #sleeping dc_vars 0

# 레이트 기본값 설정
execute unless score #rate dc_vars matches -2147483648..2147483647 run scoreboard players set #rate dc_vars 10

# 알림
tellraw @a {"text":"[DelayCycle 로드 완료]","color":"green"}