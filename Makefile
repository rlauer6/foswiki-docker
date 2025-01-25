#-*- mode: makefile-gmake; -*-
# ----------------------------------------------------------------------
# make create image and new mounted wiki if it doesn't exist
# make clean - rm container
# make realclean - remove image and your mounted wiki
# ----------------------------------------------------------------------

foswiki: Dockerfile LocalSite.cfg
	docker build . -f Dockerfile -t foswiki:latest
	if ! test -d "foswiki"; then \
	  if [[ "$$(id -u)" = "0" ]]; then \
	    test -d "/tmp/scratch" || mkdir /tmp/scratch; \
	    docker run --rm -v /tmp/scratch:/tmp/scratch foswiki:latest tar cpfvz /tmp/scratch/foswiki.tar.gz -C /var/www foswiki; \
	    tar --same-owner -xvzf  /tmp/scratch/foswiki.tar.gz  foswiki; \
	    rm -f /tmp/scratch/foswiki.tar.gz; \
	  else \
	    echo "run this a root if you want to create local foswiki directory that will preserve your wiki"; \
	  fi; \
	fi

clean:
	container_id="$$(docker ps -a | grep foswiki:latest | awk '{print $$1}')"; \
	if test -n "$$container_id"; then \
	  docker rm $$container_id; \
	fi

realclean: clean
	docker rmi foswiki:latest
	if [[ "$$(id -u)" = 0 ]]; then \
	  rm -rf foswiki; \
	else \
	  echo "run this as root to remove the 'foswiki' directory as well"; \
	if
