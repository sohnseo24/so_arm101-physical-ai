#!/bin/bash
# ------------------------------------------------------------------------------
# 4. 수집된 에피소드 재생 및 데이터셋 시각화 (Replay & Visualization)
# ------------------------------------------------------------------------------
# (1) 특정 에피소드(47번) 재현
lerobot-replay \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=my_awesome_follower_arm \
  --dataset.repo_id=$HOME/.cache/huggingface/lerobot/collect_data/candy \
  --dataset.episode=47

# (2) 데이터셋 시각화
lerobot-dataset-viz \
  --repo-id=$HOME/.cache/huggingface/lerobot/collect_data/candy \
  --episode-index=0 \
  --display-compressed-images=true