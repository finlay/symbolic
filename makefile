IMAGE := finlay/symbolic:v2
RUN ?= docker run -it --net host --rm \
		-v $$PWD:/work -w /work \
		-v $$HOME:/home \
		-u $$(id -u):$$(id -g) \
		-e HOME=/home \
		$(IMAGE)

paper/paper.html: paper/paper.tex
	$(RUN) bash -c '(cd paper; xelatex paper.tex)'



interact:
	docker run -it --net host --rm \
		-v $$PWD:/work -w /work \
		-v $$HOME:/home \
		-u $$(id -u):$$(id -g) \
		-e HOME=/home \
		-e RUN= \
		$(IMAGE) bash

docker:
	docker build -t $(IMAGE) .

docker-push:
	docker push $(IMAGE)
