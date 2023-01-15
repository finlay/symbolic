IMAGE := finlay/symbolic:v2
RUN ?= docker run -it --net host --rm \
		-v $$PWD:/work -w /work \
		-v $$HOME:/home \
		-u $$(id -u):$$(id -g) \
		-e HOME=/home \
		$(IMAGE)

paper/paper.html: paper/paper.tex paper/brauer.tex paper/fexpand.tex
	$(RUN) bash -c '(cd paper; xelatex paper.tex)'

paper/brauer.tex: app/Main.hs
	$(RUN) bash -c 'cabal run -v0 symbolic brauer > $@'

paper/fexpand.tex: app/Main.hs
	$(RUN) bash -c 'cabal run -v0 symbolic fexpand > $@'

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
