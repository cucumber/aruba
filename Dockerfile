FROM ruby:2.4

# Create guest user early (before rvm) so uid:gid are 1000:000
RUN useradd -m -s /bin/bash guest

# Fix locale
#ENV DEBIAN_FRONTEND noninteractive
#RUN dpkg-reconfigure locales && locale-gen en_US.UTF-8 && /usr/sbin/update-locale LANG=en_US.UTF-8 \
   #&& echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
#ENV LC_ALL C.UTF-8
#ENV LANG C.UTF-8
#ENV LANGUAGE C.UTF-8

# Zsh (just for the sake of a handful of Cucumber scenarios)
# Python (just for the sake of a handful of Cucumber scenarios)
# Java (for javac - also for just a few Cucumber scenarios)
RUN apt-get update -qq
RUN apt-get -y install zsh --no-install-recommends
RUN apt-get -y install python --no-install-recommends
#RUN apt-get -y install openjdk-7-jdk --no-install-recommends

# Cache needed gems - for faster test reruns
ADD Gemfile Gemfile.lock aruba.gemspec /home/guest/cache/aruba/
ADD lib/aruba/version.rb /home/guest/cache/aruba/lib/aruba/version.rb
RUN chown -R guest:guest /home/guest/cache

USER guest
ENV HOME /home/guest
WORKDIR /home/guest

# Download and install aruba + dependencies
WORKDIR /home/guest/cache/aruba
RUN bash -l -c "bundle install"

# Default working directory
RUN mkdir -p /home/guest/aruba
WORKDIR /home/guest/aruba

CMD ["bundle exec rake test"]
