# Instructions
# ------------
#
# This Dockerfile will always target the lowest version of Ruby supported by
# Aruba. This is currently version 2.4.0.
#
# Build the Docker image using:
#
#   docker build -t test-aruba .
#
# You can pick any image name instead of test-aruba, of course. After the
# build is done, run bash interactively inside the image like so:
#
#   docker run -v $PWD:/aruba --rm -it test-aruba:latest bash
#
# The `-v $PWD:/aruba` will make the container pick up any changes to the
# code, so you can edit and re-run the tests.

FROM ruby:2.4

# Create aruba user
RUN useradd -m -s /bin/bash aruba

RUN mkdir /aruba
RUN chown aruba:aruba /aruba

# Run the rest of the steps as non-root
USER aruba
WORKDIR /aruba

# Ensure Bundler 2.x is installed
RUN gem update bundler

# Add just the files needed for running bundle install
ADD Gemfile aruba.gemspec Manifest.txt /aruba/
ADD lib/aruba/version.rb /aruba/lib/aruba/version.rb
ADD exe/aruba /aruba/exe/aruba

# Install dependencies
RUN bundle

# Add the full source code
ADD . /aruba
