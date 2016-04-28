FROM ubuntu:14.04
MAINTAINER Aruba Maintainers <cukes-devs@googlegroups.com>

# Packages needed to install RVM and run Bundler gem commands
RUN apt-get update -qq \
  && apt-get -y install ca-certificates curl git-core --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Create guest user early (before rvm) so uid:gid are 1000:000
RUN useradd -m -s /bin/bash guest

# Temporarily install RVM as root - just for requirements
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && curl -L get.rvm.io | bash -s stable \
  && bash -l -c 'rvm requirements 2.2.1' \
  && bash -l -c 'echo yes | rvm implode' \

# Fix locale
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure locales && locale-gen en_US.UTF-8 && /usr/sbin/update-locale LANG=en_US.UTF-8 \
   && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

# Zsh (just for the sake of a handful of Cucumber scenarios)
RUN apt-get update -qq \
  && apt-get -y install zsh --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Python (just for the sake of a handful of Cucumber scenarios)
RUN apt-get update -qq \
  && apt-get -y install python --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Java (for javac - also for just a few Cucumber scenarios)
RUN apt-get update -qq \
  && apt-get -y install openjdk-7-jdk --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Cache needed gems - for faster test reruns
ADD Gemfile Gemfile.lock aruba.gemspec /home/guest/cache/aruba/
ADD lib/aruba/version.rb /home/guest/cache/aruba/lib/aruba/version.rb
RUN chown -R guest:guest /home/guest/cache

USER guest
ENV HOME /home/guest
WORKDIR /home/guest

# Install RVM as guest
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc" \
  && curl -L get.rvm.io | bash -s stable \
  && /bin/bash -l -c "rvm install 2.3.0 && rvm cleanup all" \
  && /bin/bash -l -c "gem install bundler --no-ri --no-rdoc" \
  && echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc \
  && echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.zshrc

# Download and install aruba + dependencies
WORKDIR /home/guest/cache/aruba
RUN bash -l -c "bundle install"

# Default working directory
RUN mkdir -p /home/guest/aruba
WORKDIR /home/guest/aruba

CMD ["bundle exec rake test"]
