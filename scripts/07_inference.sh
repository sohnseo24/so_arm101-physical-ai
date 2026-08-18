#!/bin/bash
# ------------------------------------------------------------------------------
# 07. SmolVLA / Custom Inference 스크립트 (키 매핑 패치 파이썬 실행)
# ------------------------------------------------------------------------------

# [CPU 스레드 병목 해소]
export OMP_NUM_THREADS=4
export OPENBLAS_NUM_THREADS=4
export MKL_NUM_THREADS=4

conda activate lerobot 2>/dev/null || true
cd ~/Desktop/sscc/lerobot

# 커스텀 파이썬 추론 스크립트 직접 실행 (SmolVLA 키 변환 보장)
python lerobot_inference.py \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=so101_follower_arm \
  --robot.cameras='{"top": {"type": "opencv", "index_or_path": 2, "width": 640, "height": 480, "fps": 25}, "gripper": {"type": "opencv", "index_or_path": 0, "width": 640, "height": 480, "fps": 25}}' \
  --policy.path=outputs/train/bae/smolvla_all/checkpoints/last/pretrained_model \
  --instruction="Pick a yellow candy" \
  --display_data=true