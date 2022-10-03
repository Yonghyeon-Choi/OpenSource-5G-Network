# OpenSource 5G Network
### 오픈 소스 소프트웨어 "Open5GS", "UERANSIM"을 이용한 클라우드 컴퓨터, 컨테이너 기반의 5G 네트워크

* 개요\
  Open5GS에서 만든 5G 네트워크의 Core Network를 C로 구현하고 AGPL V3.0 라이센스를 보유한 Release-16 기반 오픈 소스 소프트웨어 [Open5GS](https://github.com/open5gs/open5gs), 
  엔지니어 Ali Güngör가 만든 5G 네트워크의 UE, RAN을 C, Java로 구현하고 GPL V3.0 라이센스를 보유한 Release-15 기반 오픈 소스 소프트웨어 [UERANSIM](https://github.com/aligungr/UERANSIM)
  을 사용, docker-compose를 이용하여 한정된 자원(1대의 인스턴스, 서버, 로컬 머신)에서 5G Virtual Network를 구성하는 프로젝트\
  해당 프로젝트를 이용해 여러 사람이 본인의 인스턴스에서 5G Virtual Network를 구성하여 5G 통신에서의 취약점을 테스트 해볼 수 있음\
  3GPP에서 제시하는 5G 구조에서 5G 무선 밴드에서의 무선 통신, LAN 네트워크 구성에서의 통신 중에서 UERANSIM은 후자를 채택했으며 Ubuntu 기반에서 구현한 것이 특징


* 5G 시스템 구조\
  ![image](https://user-images.githubusercontent.com/32658266/193646814-18032f94-d519-4759-9132-1dfcd2e25fd4.png)\
  5G 네트워크는 크게 UE, RAN, Core Network로 구분할 수 있으며, 외부 연동기관으로 DN(Data Network)가 있음\
  UE는 스마트폰, RAN는 무선 기지국, Core Network는 통신사 서버, DN은 인터넷에 비유하면 이해가 쉬움

* 5G 네트워크 프로토콜 스택\
  ![3GPP 프로토콜 스택](https://user-images.githubusercontent.com/32658266/193644002-26e5e092-aad9-4d31-b5b8-74eb7633d33c.png)\
  5G 시스템 구조에서 많은 엣지가 존재하는데 UE, RAN, Core Network가 통신하기 위한 N1, N2, N3 엣지에서\
  User Plane, Control Plane을 동작하기 위해 사용되는 프로토콜 스택 이미지로 아래와 같은 프로토콜이 사용됨\
  UE ~ RAN : PDCP\
  RAN ~ CN : SCTP, UDP

* UERANSIM, Open5GS를 사용한 5G Virtual Network의 구조\
  ![구조도](https://user-images.githubusercontent.com/32658266/193643130-ff254d69-9c0b-4e10-bf08-1498c1831d10.png)\
  단일 인스턴스에서 3개의 컨테이너에 각각 UE, RAN, Core Network를 실행하였음\
  각 컨테이너는 Ubuntu 20.04를 기반으로 동작

* UERANSIM, Open5GS를 사용한 5G Virtual Network의 사용 프로토콜\
  ![통신](https://user-images.githubusercontent.com/32658266/193643495-da3df861-e1eb-4f9e-a678-481a16e9e001.png)\
  [UERANSIM Feature Set](https://github.com/aligungr/UERANSIM/wiki/Feature-Set), [UERANSIM Configuration](https://github.com/aligungr/UERANSIM/wiki/Configuration)
  에서 설명하고 있는 바로, UE ~ RAN 구간의 PDCP 프로토콜을 이용한 5G 무선 통신을 UERANSIM에서는 UDP 프로토콜로 대체해 Virtual Network를 구현했으며,\
  나머지 User Plane과 Control Plane에서의 SCTP, UDP 프로코톨은 3GPP에서 제시한 프로토콜을 사용하고 있음을 알 수 있음\
  실제 각 컨테이너 간 통신이 UDP, SCTP로 모두 이루어져 있음을 "netstat -nap"과 같은 단순한 명령어로도 확인이 가능


## 실행 방법

* git clone\
  cd ~/\
  git clone https://github.com/Yonghyeon-Choi/OpenSource-5G-Network

* docekr-compose 실행\
  cd OpenSource-5G-Network\
  docker-compose -f docker-compose-5g-default.yml up -d && docker restart 5G_UE

* 5G Core 네트워크 실행\
  docker exec -it 5G_CN /bin/bash\
  ./run.sh\
  ctrl + P,Q
  
* Open5GS Web UI, 5G Core 네트워크에 구독자 등록\
  웹브라우저에서 http://{현재인스턴스의공인IP}\
  ID : admin, Password : 1423\
  ![image](https://user-images.githubusercontent.com/32658266/193664824-623758fb-1a04-4199-9a53-f7ef3e07f870.png)\
  단말기 식별번호(IMSI)로 901700000000001를 등록\
  Open5GS Web UI에 접속하여 구독자를 등록해야 UERANSIM의 UE에서 네트워크 사용이 가능함\
  스마트폰 개통 과정이라 이해하면 쉬움


* 5G RAN 재실행\
  docker restart 5G_RAN

* 5G UE에서 5G 네트워크 사용
  * 컨테이너 웹 접속\
  웹브라우저에서 https://{현재인스턴스의공인IP}\
  ID : root, Password : 1234\
  ![image](https://user-images.githubusercontent.com/32658266/193657612-9e0ce160-23d3-444d-9d69-a3bdb4875604.png)\
  ![image](https://user-images.githubusercontent.com/32658266/193657719-e002a27e-62de-43df-82ac-a3ca38117310.png)\
  * 터미널 실행 : 시작메뉴 > System Tools > LXTerminal\
  ![image](https://user-images.githubusercontent.com/32658266/193661387-c2e505b6-1d5c-4d84-9258-e5ea04db2a22.png)\
  * UE 프로세스 실행 : ./UERANSIM/build/nr-ue -c UERANSIM/config/open5gs-ue.yaml\
  ![image](https://user-images.githubusercontent.com/32658266/193661619-90bf692b-8113-4af0-a80d-04ffaebfaef8.png)\
  * 5G 네트워크를 경유하는 웹브라우저 실행 : ./UERANSIM/build/nr-binder 10.45.0.23 firefox\
  ![image](https://user-images.githubusercontent.com/32658266/193662300-82ca9619-3c7e-4be0-a245-1e633612e246.png)\
  ![image](https://user-images.githubusercontent.com/32658266/193662354-0001f086-95c1-4860-aec3-3dd1a0043e0c.png)\
  UE 프로세스 재실행 및 웹브라우저 이외의 앱을 실행시 10.45.0.23와 firefox 옵션은 바뀔 수 있음\
  UE 프로세스 재실행마다 Core Network인 Open5GS에서 10.45.0.2부터 1씩 증가하여 새로 IP 할당\
  firefox앱 대신 크롬을 설치하여 chrome이라고 옵션을 변경하거나, 안드로이드 에뮬레이터를 설치하여 실행가능

* docker-compose 종료\
  docker-compose -f docker-compose-5g-default.yml down

## Open5GS, UERANSIM Docs
* https://open5gs.org/open5gs/docs/
* https://github.com/aligungr/UERANSIM/wiki

## 참고 블로그
* [Open5GS + UERANSIM 으로 5G 네트워크 구축하기](https://frontjang.tistory.com/entry/Open5GC-UERANSIM-%EC%9C%BC%EB%A1%9C-5G-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0-1-%EA%B5%AC%EC%84%B1-%EB%B0%8F-%EC%84%A4%EC%B9%98?category=670780)
* [Deploying 5G Core Network with Open5GS and UERANSIM](https://medium.com/rahasak/5g-core-network-setup-with-open5gs-and-ueransim-cd0e77025fd7)

## 참고 문서
* Kim, Mun-Hong, et al. "5G 이동통신기술 발전방향." Information and Communications Magazine 32.9_spc (2015): 46-54.
* 송종태, et al. "5G 네트워크 구조 분석." Telecommunications Review 25.6 (2015): 884-898.
* Jo, Chang-Gil. "Special Report-5G 네트워크 기술 동향." TTA Journal (2016): 58-63.


## 참고 3GPP 문서
  ![image](https://user-images.githubusercontent.com/32658266/193656079-d9f016dc-20a1-4262-b04f-b3aaf3380700.png)
