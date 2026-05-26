# 매크로 기능을 이용해 입력받은 값을 변수에 덮어씌웁니다.
$scoreboard players set #rate dc_vars $(rate)

# 변경 안내 메시지
$tellraw @a [{"text":"[DelayCycle] 낮/밤 사이클 속도가 "}, {"text":"$(rate)", "color":"gold"}, {"text":" 로 설정되었습니다! (10 = 기본속도)"}]