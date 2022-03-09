DOCKERFILE = weather-app-dockerfile

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

.PHONY: refresh
refresh:
	aws ecs update-service --cluster ravis-weatherapp-ecs-cluster --service ravis-weatherapp-ecs-service --force-new-deployment --region us-east-1