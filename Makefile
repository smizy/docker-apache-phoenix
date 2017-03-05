
.PHONY: all
all: runtime

.PHONY: clean
clean:
	docker rmi -f smizy/apache-phoenix:${TAG} || :

.PHONY: runtime
runtime:
	docker build \
		--build-arg BUILD_DATE=${BUILD_DATE} \
		--build-arg VCS_REF=${VCS_REF} \
		--build-arg VERSION=${VERSION} \
		-t smizy/apache-phoenix:${TAG} .
	docker images | grep apache-phoenix

.PHONY: test
test:
	(docker network ls | grep vnet ) || docker network create vnet
	docker-compose -f docker-compose.yml up -d 
	docker-compose ps
	docker run --net vnet -e HBASE_ZOOKEEPER_QUORUM=zookeeper-1.vnet:2181 --volumes-from regionserver-1 smizy/apache-phoenix:${VERSION}-alpine  bash -c 'for i in $$(seq 200); do nc -z regionserver-1.vnet 16020 && echo test starting && sleep 10 && break; echo -n .; sleep 1; [ $$i -ge 200 ] && echo timeout && exit 124 ; done'

	bats test/test_*.bats

	docker-compose -f docker-compose.yml stop
