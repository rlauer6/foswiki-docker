FROM debian:bookworm AS httpd-debian

COPY bookworm-backports.list /etc/apt/sources.list.d/
RUN apt-get update && apt-get install -y \
    less vim git automake less gcc gnupg \
    apache2 libapache2-mod-perl2 apache2-dev libapache2-mod-apreq2 \
    libssl-dev wget rcs curl

RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm -n -v CGI CGI::Session Crypt::PasswdMD5 File::Copy::Recursive JSON::XS JSON \
                Email::MIME Email::Address::XS Email::Simple Locale::Language

RUN wget https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x09/Foswiki-2.1.9.tgz
RUN tar xfvz $(ls -1 Foswiki* | head -1)

RUN mv Foswiki-2.1.9 /var/www/foswiki
RUN chown -R www-data:www-data /var/www/foswiki/
RUN a2enmod cgi
RUN a2enmod rewrite

COPY foswiki.conf /etc/apache2/conf-enabled
COPY start-foswiki /usr/local/bin/start-foswiki
COPY LocalSite.cfg /var/www/foswiki/lib

RUN chown www-data:www-data /var/www/foswiki/lib/LocalSite.cfg
RUN mkdir /tmp/scratch
CMD ["/usr/local/bin/start-foswiki"]
