#!/bin/bash
# ------------------------------------------------------------------------------
# 3. 모방 학습용 데이터 수집 (Data Recording)__ 사람이 직접 시연하며 카메라 및 관절 데이터 수집
# ------------------------------------------------------------------------------
lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=my_awesome_follower_arm \
  --robot.cameras="{ front: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, rear: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}}" \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0 \
  --teleop.id=my_awesome_leader_arm \
  --display_data=true \
  --dataset.repo_id=collect_data/candy \
  --dataset.num_episodes=10 \
  --dataset.single_task="Pick the yellow candy" \
  --dataset.push_to_hub=false \
  --resume=true