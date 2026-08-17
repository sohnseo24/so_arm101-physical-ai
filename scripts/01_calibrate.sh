#!/bin/bash
# ------------------------------------------------------------------------------
# 1. 로봇팔 영점 및 관절 보정 (Calibration)
# ------------------------------------------------------------------------------
lerobot-calibrate \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=my_awesome_follower_arm