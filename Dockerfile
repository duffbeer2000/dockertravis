FROM debian:latest

MAINTAINER Christian

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

## Install necessary packages
RUN apt-get update && apt-get install -y \
	apt-utils \
	build-essential \

CMD ["bash", "echo Hello World"]
