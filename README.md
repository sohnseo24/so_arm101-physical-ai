# SO-ARM101 기반 Physical AI & ACT, VLA 모델 조작 프로젝트

Hugging Face의 **LeRobot** 프레임워크와 **SO-ARM101** 로봇팔을 활용하여 실물 물체 조작 Task("Pick the yellow candy")를 수행하는 모방 학습(Imitation Learning) 연구 스터디 프로젝트입니다.

---

## 주요 특징 및 수행 내용
* **하드웨어 제어**: Leader-Follower 체계 구동 및 모션 시연 데이터 구축
* **AI 모델(ACT)**: Action Chunking with Transformers (ACT) 기반 엔드투엔드 로봇 제어
* **AI 모델 (VLA)**: 최신 Vision-Language-Action 파운데이션 모델(pi0/pi0.5 등)을 도입하여 자연어 텍스트 명령을 이해하고 행동하는 멀티모달 로봇 제어 파이프라인 구축 및 LoRA 기반 파인튜닝
* **핵심 과제**: Task("Pick the yellow candy")를 수행하고, 모방 학습에서의 데이터 품질 및 궤적 오차가 모델 성능에 미치는 영향 분석, ACT 대비 VLA 모델의 자율성 및 제어 성능 비교 분석

---

## 파이프라인 및 스크립트 실행 안내

모든 실행 스크립트는 `scripts/` 폴더 내에 정의되어 있으며, 아래 순서대로 실행을 권장합니다.

```bash
# 0. 개발 환경 세팅 (Conda, LeRobot 및 의존성 패키지)
bash scripts/00_setup_env.sh

# 1. 포트 권한 설정 및 로봇팔 보정 (Calibration)
bash scripts/01_calibrate.sh

# 2. 카메라 시야각 점검 및 원격 조종 (Teleoperation)
bash scripts/02_teleop.sh

# 3. 고품질 시연 데이터 수집 (Data Collection)
bash scripts/03_record_dataset.sh

# 4. 수집 데이터 재생 및 시각화 검증
bash scripts/04_replay_viz.sh

# 5. ACT AI 모델 직접 학습 (Model Training)
bash scripts/05_train_act.sh

# 6. CPU 병목 방지 최적화 적용 실시간 로봇 구동 (Rollout)
bash scripts/06_rollout_eval.sh

---

## 폴더 구조

so_arm101-physical-ai/
├── scripts/
│   ├── 00_setup_env.sh       # 환경 구축 스크립트 (Miniforge, Conda, pip)
│   ├── 01_calibrate.sh       # 로봇 보정 스크립트
│   ├── 02_teleop.sh          # 원격 조종 스크립트
│   ├── 03_record_dataset.sh  # 데이터 수집 스크립트 (단축키 팁 포함)
│   ├── 04_replay_viz.sh      # 데이터 재현 및 시각화 스크립트
│   ├── 05_train_act.sh       # ACT 모델 학습 스크립트 (lerobot-train)
│   └── 06_rollout_eval.sh    # 모델 롤아웃 & CPU 스레드 최적화 스크립트
├── docs/
│   └── troubleshooting.md    # 데이터 수집 및 학습 오류 분석 노트
├── .gitignore
└── README.md                 # 파이프라인 및 데이터 수집 단축키 안내 업데이트

---

## 🛠 SO-ARM101 & ACT Model Troubleshooting Log

### Issue 1: 데이터 수량 증대(50개 -> 150개) 시 모델 성능 저하 현상
* **상황**: 데이터양을 늘렸음에도 불구하고 사탕을 집지 못하거나 멈칫거리는 현상이 심해짐(50개 데이터로 학습했을 때보다 150개 데이터로 학습 시 사탕을 놓치거나 동작 속도가 저하되었음)
* **원인 분석**:
  * 1. 데이터 수집 방법: 데이터 수집 시 '물체 위에서 1~2초 정지'하는 구분 동작을 포함해 수집함.- ACT 모델은 시연자의 동작을 매우 솔직하게 모방하므로, 사람의 멈칫하는 불필요한 관절 습관까지 그대로 정답 데이터로 학습하여 AI의 행동패턴으로 고착화 되었음. 
  * 2. 환경오차: 조명 변화 및 데이터 수집 시 매뉴얼 조종의 일관성 부족.
* **해결 방안**:
  * 단순 데이터수 증가보다 부드럽고 끊김 없는 연속동작으로 이루어진 '고품질 데이터 50개'가 훨씬 효과적임을 확인.
  * 하드웨어 위치 고정 및 환경 통제 강화: 조작 속도, 일관성, 물리적 카메라 각도 고정, 빛의 환경을 엄격히 통제한 재수집 필요.



### Issue 2: Teleop 시에는 손목(Wrist, ID 4)이 정상 작동하지만 Record 시 동작하지 않는 문제
* **원인**: `teleoperate` 명령어 실행 시에는 `--robot.id` 옵션이 지정되지 않아 `None.json` 캘리브레이션을 참조하는 반면, `record` 시에는 `so101_follower_arm.json`을 참조하여 발생한 **캘리브레이션 파일 미스매치** 현상
* **해결방법**: 새로 캘리브레이션을 진행한 후 생성된 `None.json` 파일을 사용할 ID 이름으로 복사하여 일치시켜 주기 
  ```bash
  cp sscc-soarm/robots/so_follower/None.json sscc-soarm/robots/so_follower/so101_follower_arm.json
  cp sscc-soarm/teleoperators/so_leader/None.json sscc-soarm/teleoperators/so_leader/so101_leader_arm.json

### Issue 3: USB 장치 포트 인식 순서 꼬임(/dev/ttyACM0 vs /dev/ttyACM1)
* **원인**:  PC를 재부팅하거나 USB 케이블을 다르게 꽂으면 리더(Leader)와 팔로워(Follower)의 포트 번호가 서로 바뀌어 명령어가 실패함(Linux kernel이 USB 연결 순서에 따라 /dev/ttyACM0, ttyACM1을 가변적으로 할당하기 때문).
