DOCKERFILE = weather-app-dockerfile
ECSTASKRESTART = for taskarn in $(aws ecs list-tasks --cluster ravis-weatherapp-ecs-cluster --service ravis-weatherapp-ecs-service --desired-status RUNNING --output text --query 'taskArns'); do aws ecs stop-task --cluster ravis-weatherapp-ecs-cluster --task $taskarn; done;

ACCOUNTID = 152848913167
AWSREGION = us-east-1
REPONAME = ravis-node-weather-app

.PHONY: build
build:
	docker build -t $(ACCOUNTID).dkr.ecr.$(AWSREGION).amazonaws.com/$(REPONAME):1 -f $(DOCKERFILE) .

.PHONY: login
login:
	aws ecr get-login-password --region $(AWSREGION) | docker login --username AWS --password-stdin $(ACCOUNTID).dkr.ecr.$(AWSREGION).amazonaws.com

.PHONY: push
push:
	docker push $(ACCOUNTID).dkr.ecr.$(AWSREGION).amazonaws.com/$(REPONAME):1

.PHONY: ecstask
ecstask:
	$(ECSTASKRESTART)