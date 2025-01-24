# README

Docker environment for [Foswiki](https://foswiki.org/Home/WebHome)

# Install

```
docker build . -f Dockerfile -t foswiki:latest
docker-compose up
```

# Notes

If you are trying to install Foswiki from the instruction on their
website, here are some caveats gotchas. Essentially Foswiki is a Perl
based web application that implements a content managment system.  It
is designed to run primarily on an Apache web server. Given the number
of different environment in which that type of application can run
in, it's not surprising that the installation procedure may need to be
customized depending on your distro flavor.

Here's what I experienced trying to get this to work on Debian
_bookworm_:

* install `App::cpanminus` and save your self from Perl library
installation nightmares.
  ````
  curl -L https://cpanmin.us | perl - App::cpanminus 
  ````
* the `perldependencies` utility may not catch all of the missing
  dependencies I noted that `Locale::Language` was not called out but
  is required.
* If you want version controlled, wiki pages, you'll need `rcs`.

Other that the hiccups above, it went rather smoothly.

# Ideas, Suggestions and Next Steps

* I've used TWiki before and installed it on an EC2.  I mounted the
`/twiki` directory to an EFS mount because it created a highly
available data storage capability.  EFS is not only redundant across
AZs, you can configure backups that are relatively cheap.
* With Docker and `docker-compose` you can set up a volume that is
  mapped to an EFS of other form of persistent storage.
* [ ] Setup an ECS (Fargate) version of Foswiki
* [ ] Setup an EKS (Kubernetes) version of Foswiki
* [ ] Enable SSL
