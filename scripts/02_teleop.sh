#!/bin/bash
# ------------------------------------------------------------------------------
# 2. 리더-팔로워 원격 조종 제어 (Teleoperation)
# ------------------------------------------------------------------------------
lerobot-teleoperate \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=my_awesome_follower_arm \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0 \
  --teleop.id=my_awesome_leader_arm

#!/bin/bash
# ------------------------------------------------------------------------------
# 2. 텔레오퍼레이션 및 카메라 연결 점검 (Teleop & Camera Check)
# ------------------------------------------------------------------------------

sudo chmod 666 /dev/ttyACM* /dev/video*

# 카메라 장치 연결 확인
ls -l /dev/video*

# [선택] 탑뷰/그리퍼뷰 실시간 카메라 화면 출력 확인 (별도 터미널 실행 권장)
# ffplay /dev/video32 &
# ffplay /dev/video34 &

# 원격 조종 실행
lerobot-teleoperate \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0


# 주요 변경 사항
# 기존코드: 단순 원격 조종 명령어만 포함한 스크립트
# 새코드: 카메라 연동, 사전 환경점검 단계가 강화된 스크립트
# 1. 카메라 장치 연결 점검 및 프리뷰 가이드 추가
#    - ls -l /dev/video* 명령으로 카메라 장치 번호를 확인
#    - ffplay를 이용해 탑뷰 및 그리퍼뷰 실시간 화면을 띄워볼 수 있음
# 2. 장치 접근 권한 대상 확장 (sudo chmod 666)
#    - 시리얼 통신 포트(/dev/ttyACM*)뿐만 아니라 카메라(/dev/video*)까지 권한 부여 대상에 포함 
#    => 카메라 영상 스트림을 읽어오는 과정에서 발생할 수 있는 Permission denied 에러 방지 
# 3. --robot.id 및 --teleop.id 커스텀 옵션 제거
#    - 기본값 설정 프로필을 사용하도록 통일 -> 커스텀 ID 사용 시 캘리브레이션 파일 경로가 어긋나거나 인식 에러가 발생하는 문제 방지