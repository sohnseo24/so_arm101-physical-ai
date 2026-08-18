#!/bin/bash
# ------------------------------------------------------------------------------
# 05. ACT AI 모델 학습(수집된 데이터셋을 바탕->GPU(CUDA)를 활용하여 ACT 정책(Policy) 모델 학습)
# ------------------------------------------------------------------------------

conda activate lerobot
cd ~/Desktop/sscc/lerobot

# GPU(CUDA) 환경에서 50,000 스텝 동안 ACT 모델 학습 진행
lerobot-train \
  --dataset.repo_id=local/candy_data \                  # 학습에 사용할 로컬 데이터셋 이름
  --dataset.root=data2 \                                 # 데이터 저장 폴더
  --policy.type=act \                                    # 사용할 AI 모델 종류 (ACT)
  --policy.device=cuda \                                 # GPU 가속 사용
  --batch_size=8 \                                       # 배치 크기 설정 (8)
  --steps=50000 \                                        # 총 학습 스텝 수 (50,000)
  --output_dir=outputs/train/act_candy_data \          # 학습 결과물(체크포인트) 저장 경로
  --policy.repo_id=local/act_candy_policy \             # 생성될 정책 모델 저장소 이름
  --dataset.video_backend=pyav                           # 비디오 로딩 백엔드 설정