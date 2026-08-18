#!/bin/bash
# ------------------------------------------------------------------------------
# 05. AI 모델 학습 (ACT & SmolVLA)
# GPU(CUDA)를 활용하여 수집된 데이터셋 기반 정책(Policy) 모델 학습 진행
# ------------------------------------------------------------------------------

conda activate lerobot
cd ~/Desktop/sscc/lerobot

# ------------------------------------------------------------------------------
# [옵션 A] ACT (Action Chunking with Transformers) 모델 학습
# ------------------------------------------------------------------------------

# GPU(CUDA) 환경에서 50,000 스텝 동안 ACT 모델 학습 진행
lerobot-train \
  --dataset.repo_id=local/candy_data \                  # 학습에 사용할 로컬 데이터셋 이름
  --dataset.root=data_bae/single_yellow \                                 # 데이터 저장 폴더
  --policy.type=act \                                    # 사용할 AI 모델 종류 (ACT)
  --policy.device=cuda \                                 # GPU 가속 사용
  --batch_size=8 \                                       # 배치 크기 설정 (8)
  --steps=50000 \                                        # 총 학습 스텝 수 (50,000)
  --output_dir=outputs/train/act_candy_data \          # 학습 결과물(체크포인트) 저장 경로
  --policy.repo_id=local/act_candy_policy \             # 생성될 정책 모델 저장소 이름
  --dataset.video_backend=pyav                           # 비디오 로딩 백엔드 설정
  --policy.chunk_size=30 \                              #미래에 수행할 30프레임 분량의 행동을 한 번에 묶어서 예측
  --policy.n_action_steps=30 \                          #예측된 30프레임 행동을 실제로 로봇팔이 연속 실행 (chunk_size와 동일하게 설정)
  --policy.kl_weight=2.0                                # CVAE 손실 함수 내 KL Divergence 가중치를 기존 기본값(10)에서 2.0으로 낮추어->모방 학습의 정밀도와 행동 유연성을 향상

  # ------------------------------------------------------------------------------
# [옵션 B] SmolVLA (Vision-Language-Action) 모델 파인튜닝 (필요 시 주석 해제 후 사용)
# ------------------------------------------------------------------------------
# lerobot-train \
#   --dataset.repo_id=local/candy_data \
#   --dataset.root=data_bae/single_yellow \
#   --policy.type=smolvla \
#   --policy.pretrained_path=lerobot/smolvla_base \
#   --policy.device=cuda \
#   --batch_size=8 \
#   --steps=30000 \
#   --output_dir=outputs/train/bae/smolvla_all \
#   --policy.repo_id=local/smolvla_candy_policy_all \
#   --dataset.video_backend=pyav \
#   --policy.chunk_size=30 \
#   --policy.n_action_steps=30