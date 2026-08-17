#!/bin/bash
# ------------------------------------------------------------------------------
# 5. 환경 변수 설정 및 ACT 모델 추론/평가 (Inference & Evaluation) __환경 변수 설정, 학습된 ACT 모델 기반 추론 실행, 평가 데이터셋 생성 및 체크포인트 파일 검증
# ------------------------------------------------------------------------------

# 환경 변수 정의
export HF_USER="my-user"
export TASK_NAME="grab_the_candy"
export TASK_DESCRIPTION="grab_the_candy"

# (1) 학습된 ACT 모델 자율 추론
lerobot-inference \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=my_awesome_follower_arm \
  --robot.cameras="{ front: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, rear: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}}" \
  --policy.path=$HOME/lerobot/outputs/train/act_so101/grab_the_candy_v2/checkpoints/last \
  --instruction="grab the candy" \
  --display_data=true

# (2) 기존 평가 데이터 캐시 삭제
rm -rf $HOME/.cache/huggingface/lerobot/$HF_USER/eval_grab_the_candy

# (3) 특정 체크포인트 모델로 동작 평가/기록
lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=my_awesome_follower_arm \
  --robot.cameras="{ front: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, rear: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}}" \
  --policy.path=$HOME/lerobot/outputs/train/act_so101/grab_the_candy/checkpoints/080000/pretrained_model \
  --dataset.repo_id=$HF_USER/eval_grab_the_candy \
  --dataset.single_task="grab the candy" \
  --dataset.push_to_hub=false \
  --display_data=true

# (4) 학습 결과 생성된 모델 가중치(.safetensors) 파일 확인
ls -lh $HOME/lerobot/outputs/train/act_so101/grab_the_candy_v2/checkpoints/*/pretrained_model/model.safetensors