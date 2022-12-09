IMAGE := finlay/symbolic:v1





interact:
	docker run -it --net host --rm \
		-v $$PWD:/work -w /work \
		-v $$HOME:/home \
		-u $$(id -u):$$(id -g) \
		-e HOME=/home \
		$(IMAGE) bash

docker:
	docker build -t $(IMAGE) .

docker-push:
	docker push $(IMAGE)
