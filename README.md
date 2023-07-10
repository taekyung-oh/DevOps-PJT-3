# 자동 재고 확보 시스템
## Architecture
<img width="864" alt="캡처" src="https://github.com/taekyung-oh/project3-msa/assets/126674247/6827da44-686d-4c06-93e5-d898df7666cb">


## Environment
<img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white"/><img src="https://img.shields.io/badge/AmazonAWS-232F3E?style=for-the-badge&logo=AmazonAWS&logoColor=white"/><img src="https://img.shields.io/badge/Serverless_Framework-181717?style=for-the-badge&logo=Serverless&logoColor=white"/><img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=Terraform&logoColor=white"/><img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=white"/><img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=Ubuntu&logoColor=white"/>


[![API Gateway - Serverless API Management](https://img.shields.io/badge/API%20Gateway-Serverless%20API%20Management-orange?style=flat-square&logo=Amazon%20AWS&logoColor=white)](https://aws.amazon.com/api-gateway/)
[![AWS Lambda](https://img.shields.io/badge/AWS%20Lambda-Serverless-orange?style=flat-square&logo=amazon-lambda)](https://aws.amazon.com/lambda/)
[![SNS - Simple Notification Service](https://img.shields.io/badge/SNS-Simple%20Notification%20Service-orange?style=flat-square&logo=Amazon%20AWS&logoColor=white)](https://aws.amazon.com/sns/)
[![SQS - Simple Queue Service](https://img.shields.io/badge/SQS-Simple%20Queue%20Service-orange?style=flat-square&logo=Amazon%20AWS&logoColor=white)](https://aws.amazon.com/sqs/)
[![SES - Simple Email Service](https://img.shields.io/badge/SES-Simple%20Email%20Service-orange?style=flat-square&logo=Amazon%20AWS&logoColor=white)](https://aws.amazon.com/ses/)
[![EC2 - Elastic Compute Cloud](https://img.shields.io/badge/EC2-Elastic%20Compute%20Cloud-orange?style=flat-square&logo=Amazon%20AWS&logoColor=white)](https://aws.amazon.com/ec2/)
[![Amazon RDS](https://img.shields.io/badge/Amazon%20RDS-Managed%20Database-orange?style=flat-square&logo=amazon-rds)](https://aws.amazon.com/rds/)



## Project Description
### User Story
✅ 온라인으로 도넛을 판매하는 <도넛-스테이츠>
어느날 유튜브 스타의 한 영상으로 주문이 급등한다.
주문 폭주로 창고의 재고는 계속 바닥나게 되고…
재고가 다 떨어지면 제조 공장에 알려 도넛 생산을 요청하고,
다시 재고를 채울 수 있는 시스템을 구축해야 한다.

또한, 안정적으로 요청을 전달하기 위한 시스템을 고려해야 하며,
비정상적으로 처리된 요청의 경우 운영팀에 상황을 알릴 수 있어야 한다.


## 목표
- 재고부족으로 인한 구매실패에 대한 조치
- 메시지 누락 상황에 대한 조치
- Legacy 시스템(Factory → Warehouse) 성능문제 조치
- 광고 중단 요청 진행 시나리오 구현
-  VIP 고객관리 프로세스 추가 시나리오 구현


## How-To 가이드
### 📍 주문&재고 관리 프로세스
#### 주문 요청
주문 요청 Lambda 함수를 Endpoint로 하는 API를 통해 주문이 요청됩니다. Lambda 함수는 RDS에 저장되어 있는 상품의 재고를 확인하고, 주문을 처리합니다.

#### 재고 요청
주문 처리시 상품 재고가 없을 경우 SNS로 재고 부족 메시지가 게시됩니다. SQS가 해당 SNS 주제를 구독하고, 재고 요청 Lambda 함수는 SQS를 Trigger로 실행되며, 공장 시스템에 재고를 요청합니다. 이때 내결함성 확보를 위해 SQS는 DLQ를 활용하여 실패 메시지를 보관합니다. DLQ에 메시지가 게시되면 재처리 Lambda 함수는 재처리 횟수를 확인하고, 기준 횟수 초과시 SNS를 통해 재고 담당자에게 Email을 발송합니다.

#### 재고 증가
상품 생산이 완료되면 공장 시스템은 API Gateway를 통해 재고 증가 Lambda 함수를 호출합니다. 해당 Lambda 함수는 생산된 재고를 RDS에 업데이트합니다.

### 📍 광고 중단 프로세스
재고 부족 시 해당 상품의 진행 중인 광고를 중단하기 위해, SQS가 재고 부족 SNS 주제를 구독합니다. 광고 중단 Lambda 함수는 SQS를 Trigger로 실행되며, RDS에 저장되어 있는 광고 여부와 담당자 연락처 정보를 확인합니다. 해당 상품이 현재 광고 진행 중이면 SES를 통해 광고 담당자에게 Email을 발송합니다.

### 📍 고객 관리 프로세스
주문 요청 시 100개 이상 구매한 고객은 VIP 고객으로 등록하기 위해 SNS에 메시지를 게시합니다. SQS가 해당 SNS 주제를 구독하고, EC2에 배포되어 있는 애플리케이션이 SQS 메시지를 pull하여 RDS에 고객 정보를 업데이트합니다. 이때 내결함성 확보를 위해 SQS는 DLQ를 활용하여 실패 메시지를 보관하며, 리드라이브를 통해 메시지를 재처리합니다.
