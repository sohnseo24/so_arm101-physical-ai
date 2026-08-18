USB 포트 재연결 시 Leader/Follower 포트 번호(ttyACM*) 꼬임 현상
원인: 리눅스 커널이 USB 연결 순서에 따라 /dev/ttyACM0, /dev/ttyACM1을 임의 할당하기 때문
해결방법: 장치 고유 시리얼 번호(Serial ID) 기반으로 udev 규칙을 등록하여 고정 심볼릭 링크를 사용

#1. 시리얼 번호 확인 
ls -l /dev/serial/by-id/

#2. /etc/udev/rules.d/99-so-arm.rules 작성
SUBSYSTEM=="tty", ATTRS{serial}=="<LEADER_SERIAL>", SYMLINK+="ttyACM_leader"
SUBSYSTEM=="tty", ATTRS{serial}=="<FOLLOWER_SERIAL>", SYMLINK+="ttyACM_follower"

#3. 규칙 적용
sudo udevadm control --reload-rules && sudo udevadm trigger

