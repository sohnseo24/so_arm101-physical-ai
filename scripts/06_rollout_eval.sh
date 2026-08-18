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

# 학습된 모델 기반 실시간 자율 로봇 제어 실행 (60초간)
lerobot-rollout \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.cameras='{"top": {"type": "opencv", "index_or_path": 32, "width": 640, "height": 480, "fps": 30}, "gripper": {"type": "opencv", "index_or_path": 34, "width": 640, "height": 480, "fps": 30}}' \
  --policy.path=outputs/train/act_candy_data/checkpoints/050000/pretrained_model \ # 50,000스텝 학습 완료된 체크포인트
  --rename_map='{"observation.images.top": "observation.images.rear", "observation.images.gripper": "observation.images.front"}' \   
  --duration=60                                          # 롤아웃 동작 시간 (60초)
#데이터 수집 시 설정한 카메라 키 이름(front, rear)과 추론/롤아웃 시 전달되는 카메라 이름(top, gripper)이 다를 경우, 
#모델이 비디오 입력을 인식하지 못해 추론 에러가 발생=>rollout전에 rename_map으로 카메라채널을 올바르게 바인딩 