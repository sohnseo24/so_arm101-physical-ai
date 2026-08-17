#!/bin/bash
# ------------------------------------------------------------------------------
# 4. 수집 데이터 재현 및 시각화 (Replay & Visualization)
# ------------------------------------------------------------------------------
sudo chmod 666 /dev/ttyACM* /dev/video*

# (1) 수집했던 카메라 영상과 관절 각도 데이터셋이 제대로 저장되었는지 모니터링 화면으로 시각화 확인 (로봇을 움직이지 않고 데이터 정합성 미리 확인)
# 창을 닫아야 아래 (2)번 로봇팔 재현 명령으로 넘어감!
lerobot-dataset-viz \
  --root=data2 \
  --repo-id=bae/candy_data_1 \
  --episode-index=0 \                                 
  --display-compressed-images=true                    
# 확인하고 싶은 에피소드 인덱스 번호 (첫 번째 시도인 0번)
# 데이터셋에 압축 저장된 이미지들을 모니터 화면에 출력

# (2) 특정 에피소드 관절 움직임 실제 로봇팔 재현 (0번 에피소드)
lerobot-replay \
  --robot.type=so101_follower \                       
  --robot.port=/dev/ttyACM1 \                         
  --robot.id=so101_follower_arm \
  --dataset.repo_id=bae/candy_data_1 \
  --dataset.episode=0                                
# 주요 변경 및 보완 사항
# 1. 03번 수집 스크립트 데이터셋 파라미터 동기화
#    - dataset.root=data2, repo_id=bae/candy_data_1, robot.id=so101_follower_arm으로 경로 통일
#    - episode=0 설정으로 신규 수집 데이터의 첫 번째 에피소드 검증
# 2. 데이터 시각화(lerobot-dataset-viz) 누락 구문 복원 및 신규 경로 적용
# 3. 장치 접근 권한 부여(sudo chmod 666) 추가