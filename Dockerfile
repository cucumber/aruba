FROM cucumber/aruba:latest

USER root

# Zsh (just for the sake of a handful of Cucumber scenarios)
RUN apt-get update -qq && apt-get -y install zsh --no-install-recommends && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Python (just for the sake of a handful of Cucumber scenarios)
RUN apt-get update -qq && apt-get -y install python --no-install-recommends && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Java (for javac - also for just a few Cucumber scenarios)
RUN apt-get update -qq && apt-get -y install openjdk-7-jdk --no-install-recommends && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

# Cache needed gems - for faster test reruns
ADD Gemfile Gemfile.lock aruba.gemspec /home/guest/cache/aruba/
ADD lib/aruba/version.rb /home/guest/cache/aruba/lib/aruba/version.rb
RUN chown -R guest:guest /home/guest/cache
USER guest

# Add gemrc for possible gem mirror config
# ADD docker.gemrc /home/guest/.gemrc

# NOTE: It's best to setup your own gem mirror/server, because:
#
# 1. Faster gems installing (especially useful when rebuilding the Docker image)
# 2. Less internet bandwidth used
# 3. Lesser load on rubygems.org servers
#
# Info: http://guides.rubygems.org/run-your-own-gem-server/#

RUN echo '---\n\
:sources:\n\
  - http://172.17.0.1:8808\n\
gem: "--no-ri --no-rdoc --source http://172.17.0.1:8808"\n'\
>> /home/guest/.gemrc

# Actually download
RUN bash -l -c "cd cache/aruba && bundle install"


WORKDIR /home/guest/aruba
