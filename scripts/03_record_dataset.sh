#!/bin/bash
# ------------------------------------------------------------------------------
# 3. 데이터 수집 (Data Collection)
# 단축키: [n] 다음 에피소드 / [r] 재녹화 / [q or Esc] 종료
# ------------------------------------------------------------------------------

sudo chmod 666 /dev/ttyACM* /dev/video*

lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=so101_follower_arm \
  --robot.cameras="{ front: {type: opencv, index_or_path: 32, width: 640, height: 480, fps: 30}, rear: {type: opencv, index_or_path: 34, width: 640, height: 480, fps: 30}}" \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0 \
  --teleop.id=so101_leader_arm \
  --display_data=true \
  --dataset.root=data2 \
  --dataset.repo_id=bae/candy_data_1 \
  --dataset.num_episodes=50 \
  --dataset.episode_time_s=15 \
  --dataset.reset_time_s=5 \
  --dataset.single_task="Pick the yellow candy" \
  --dataset.push_to_hub=false \
  --resume=false

# 주요 변경 사항
# 기존코드: 10회 분량의 단순 테스트용 데이터 수집 스크립트
# 새코드: 모델 학습용 데이터셋(50회) 자동화 수집 스크립트
# 1. 데이터 수집 시간 및 루프 제어 옵션 추가
#    - num_episodes: 10회 -> 50회 확대 (모델 학습을 위한 최소 데이터 확보)
#    - episode_time_s: 에피소드당 15초 고정 수집으로 데이터 균일화
#    - reset_time_s: 5초의 환경 리셋(물체 재배치) 대기 시간 부여
# 2. 저장 경로 명시 및 새로운 데이터 세션 생성
#    - root=data2 지정하여 로컬 저장 디렉터리 분리
#    - resume=false 설정으로 bae/candy_data_1 경로에 새로 녹화
# 3. 실측 기반 카메라 포트 인덱스 수정 (2, 0 -> 32, 34)
