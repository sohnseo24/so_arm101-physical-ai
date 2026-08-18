#!/bin/bash
# ------------------------------------------------------------------------------
# 06. 실시간 AI 롤아웃 및 CPU 병목 최적화
# ------------------------------------------------------------------------------

# [CPU 병목 방지 및 프레임방어 최적화] 멀티스레딩 강제 할당
export OMP_NUM_THREADS=4
export OPENBLAS_NUM_THREADS=4
export MKL_NUM_THREADS=4
#PyTorch 기반 모델 추론 시 CPU 코어 스레드 병목 현상으로 로봇 동작에 프레임 드랍이나 멈칫거림이 발생할 수 있음
#06_rollout_eval.sh 실행 전 스레드 수를 제한하여 연산 병목 해소

# Conda 가상환경 활성화 (오류 방지)
conda activate lerobot 2>/dev/null || true
cd ~/Desktop/sscc/lerobot

# ------------------------------------------------------------------------------
# [옵션 A] ACT 모델 기반 자율 동작 (Rollout)
# ------------------------------------------------------------------------------
lerobot-rollout \
  --strategy.type=base \
  --policy.path=outputs/train/bae/act_single_default/checkpoints/last/pretrained_model \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=so101_follower_arm \
  --robot.cameras='{"top": {"type": "opencv", "index_or_path": 2, "width": 640, "height": 480, "fps": 30}, "gripper": {"type": "opencv", "index_or_path": 0, "width": 640, "height": 480, "fps": 30}}' \
  --duration=0 \
  --display_data=true

# ------------------------------------------------------------------------------
# [옵션 B] SmolVLA (Vision-Language-Action) 모델 기반 자율 동작 (필요 시 주석 해제)
# ------------------------------------------------------------------------------
# lerobot-rollout \
#   --strategy.type=base \
#   --policy.path=outputs/train/bae/smolvla_all/checkpoints/last/pretrained_model \
#   --robot.type=so101_follower \
#   --robot.port=/dev/ttyACM0 \
#   --robot.id=so101_follower_arm \
#   --robot.cameras='{"top": {"type": "opencv", "index_or_path": 2, "width": 640, "height": 480, "fps": 30}, "gripper": {"type": "opencv", "index_or_path": 0, "width": 640, "height": 480, "fps": 30}}' \
#   --task="Pick a yellow candy" \
#   --duration=0 \
#   --display_data=true