#!/bin/bash
# ------------------------------------------------------------------------------
# 5. 환경 변수 설정 및 ACT 모델 추론/평가 __환경 변수 설정, 학습된 ACT 모델 기반 추론 실행, 평가 데이터셋 생성 및 체크포인트 파일 검증
# ------------------------------------------------------------------------------

# 시스템 및 AI 저장소에서 인식할 기본 정보(사용자 이름, 작업 이름)를 환경 변수로 선언
export HF_USER="my-user"                              # Hugging Face 사용자 ID 설정
export TASK_NAME="grab_the_candy"                     # 실행하려는 작업의 태스크 식별명
export TASK_DESCRIPTION="grab_the_candy"              # 작업에 대한 상세 설명

# (1) 학습 완료된 AI(ACT Policy) 모델에 실시간 카메라 영상과 지시어를 입력하여 로봇팔을 자율 제어(추론)
lerobot-inference \
  --robot.type=so101_follower \                        # 자율적으로 움직일 팔로워 로봇팔
  --robot.port=/dev/ttyACM1 \                         # 로봇팔 연결 USB 포트
  --robot.id=my_awesome_follower_arm \                # 로봇 식별 ID
  --robot.cameras="{ front: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, rear: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}}" \
                                                      # AI 판단의 입력값이 될 실시간 전면/후면 카메라 설정 (640x480, 30fps)
  --policy.path=$HOME/lerobot/outputs/train/act_so101/grab_the_candy_v2/checkpoints/last \
                                                      # 로봇을 움직일 두뇌 역할을 하는 최신 AI 모델 체크포인트 경로
  --instruction="grab the candy" \                    # AI 모델에 전달하는 자연어 지시 명령어
  --display_data=true                                 # 카메라 화면과 AI의 동작 추론 과정을 모니터링 화면에 표시

# (2) 이전에 진행했던 임시 평가 결과 캐시 폴더가 있다면 삭제하여 초기화
rm -rf $HOME/.cache/huggingface/lerobot/$HF_USER/eval_grab_the_candy

# (3) 특정 학습 단계(80,000번째 스텝)의 AI 모델 가중치를 불러와 로봇의 자율 수행 성공률을 테스트하고 기록
lerobot-record \
  --robot.type=so101_follower \                        # 평가 대상 로봇 종류
  --robot.port=/dev/ttyACM1 \                         # 로봇 연결 포트
  --robot.id=my_awesome_follower_arm \                # 로봇 ID
  --robot.cameras="{ front: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, rear: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}}" \
                                                      # 평가용 카메라 설정
  --policy.path=$HOME/lerobot/outputs/train/act_so101/grab_the_candy/checkpoints/080000/pretrained_model \
                                                      # 평가에 사용할 특정 체크포인트(80,000스텝) AI 모델 파일
  --dataset.repo_id=$HF_USER/eval_grab_the_candy \    # 평가 시 구동한 로봇 움직임을 다시 기록으로 남길 저장소 경로
  --dataset.single_task="grab the candy" \            # 수행 작업 지정
  --dataset.push_to_hub=false \                       # 평가용 데이터를 웹에 올리지 않고 로컬에만 저장
  --display_data=true                                 # 모니터링 화면 표시

# (4) 학습 실행 후 AI 모델의 가중치 파일(.safetensors)이 잘 저장되었는지 파일 용량(Human-readable) 출력하여 확인
ls -lh $HOME/lerobot/outputs/train/act_so101/grab_the_candy_v2/checkpoints/*/pretrained_model/model.safetensors