#!/bin/bash
# ------------------------------------------------------------------------------
# 1. 권한 부여 및 로봇팔 보정 (Calibration & Restore)
# ------------------------------------------------------------------------------

# 시리얼 및 카메라 장치 접근 권한 부여
sudo chmod 666 /dev/ttyACM* /dev/video*

# [선택] 캘리브레이션 백업 파일 복구 (필요시 주석 해제)
# cd ~/Desktop && git clone https://github.com/jjihyeoning/sscc-soarm.git
# mkdir -p ~/.cache/huggingface/lerobot/calibration/
# cp -r sscc-soarm/* ~/.cache/huggingface/lerobot/calibration/

# 리더 암 (ttyACM0) 보정
lerobot-calibrate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0

# 팔로워 암 (ttyACM1) 보정
lerobot-calibrate \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1

# 주요 변경 사항
# 1. 장치 접근 권한 부여 명령 추가 (sudo chmod 666)
#    - Permission denied 권한 오류 해결 
#    - 매번 권한 문제를 따로 해결하지 않고, 보정 작업을 실행하자마자 통신 및 비전 센서 권한을 한 번에 확보하기 위함
# 2. 리더 암(Leader Arm) 보정 단계 추가
#    - 리더 암의 각 관절 영점(Zeroing)이 맞지 않으면 팔로워 암으로 정확한 제어 명령을 전달할 수 없으므로,
#      두 로봇팔을 모두 보정하도록 수정
# 3. 캘리브레이션 백업 파일 복구 옵션 추가 (주석)
#    - 로봇팔을 켤 때마다 매번 물리적 보정 과정(관절을 일일이 움직이는 작업)을 반복하는 것은 번거로움  
#      이미 보정해 둔 설정 파일이 있다면 Git에서 다운로드해 캐시 폴더에 덮어씌움으로써 
#      수동 보정 과정을 스킵하고 즉시 재사용할 수 있도록 함 
# 4. --robot.id 커스텀 식별자 옵션 제거
#    - 기존 팔로워 보정 명령에 있던 --robot.id=my_awesome_follower_arm 인자 제거
#    => 명령어를 표준 기본값(Default) 위주로 간소화해서 ID가 변경되어 경로 혼선이 생기는 일을 방지  
