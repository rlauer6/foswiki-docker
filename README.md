# README

Docker environment for [Foswiki](https://foswiki.org/Home/WebHome)

# Creating a Docker Image

Use the `Makefile` to build the Docker image. The `Makefile` will
create the image and create a local copy of your wiki data which will
be mounted each time you bring the container up. This way your changes
to your wiki site will be preserved.

| Commmand | Description |
| -------- | ----------- |
| `make` | create the image (but not a local copy of your wiki) }
| `sudo make` | create the image and create a local copy of your wiki suitable for mounting |
| `make clean` |  remove the container |
| `make realclean` | remove the container and image |
| `sudo make realclean` | remove the contain, the image and your local wiki! |

To bring the wiki up:

```
docker-compose --env debian.env up
```

# Notes

If you're trying to install Foswiki from the instruction on their
website, here are some caveats and gotchas.

Essentially Foswiki is a Perl based web application that implements a
content management system.  It is designed to run primarily on an
Apache web server although I'm sure you can get this to work with
other web server as well. Given the number of different environments
in which that type of application can run in, it's not surprising that
the installation procedure may need to be customized depending on your
distro flavor.

Here's what I experienced trying to get this to work on Debian
_bookworm_:

* First install `App::cpanminus` and save your self from Perl library
installation nightmares.
  ````
  curl -L https://cpanmin.us | perl - App::cpanminus 
  cpanm -n -v CGI CGI::Session Crypt::PasswdMD5 File::Copy::Recursive JSON-XS JSON \
             Email::MIME Email::Address::XS Email::Simple Locale::Language
  ````
* the `perldependencies` utility may or may not catch all of the missing
  dependencies. I noted that `Locale::Language` was not called out but
  is required.
* If you want version controlled wiki pages, you'll need `rcs`
  ```
  apt-get update && apt-get install -y rcs
  ```

Other than the hiccups above, it went rather smoothly. :-)

# Configuration

The `docker-compose.yml` file will mount `LocalSite.cfg` for you so
you are presented here with a __somewhat__ configured Foswiki
installation.  The `admin` password is __not__ set in that file
however, so before you can run `configure` again, set the `admin`
password manually.

1. Create a password
   ```
   docker exec -it foswiki-docker_web_1 htpasswd -n -b admin MySecretPassword
   admin:$apr1$XjO.XI8I$5ylo2CfNqckc3pufhV71m.
   ```
2. edit `LocalSite.cg` in this directory and set the admin password to the
   part of the returned string after the ":"
   ```
   $Foswiki::cfg{Password} = '$apr1$XjO.XI8I$5ylo2CfNqckc3pufhV71m.';
   ```

You can also set other values for other features in the `LocalLib.cfg`
file manually at this time if you know what you are doing. By mounting
this file you'll now have a consistent Foswiki installation whenever
you bring up the container.

# Ideas, Suggestions and Next Steps

* I've used TWiki before and installed it on an EC2.  I mounted the
`/twiki` directory to an EFS mount because it created a highly
available data storage capability.  EFS is not only redundant across
AZs, you can configure backups that are relatively cheap.
* With Docker and `docker-compose` you can set up a volume that is
  mapped to an EFS or other form of persistent storage.
* [ ] Setup an ECS (Fargate) version of Foswiki
* [ ] Setup an EKS (Kubernetes) version of Foswiki
* [ ] Enable SSL
