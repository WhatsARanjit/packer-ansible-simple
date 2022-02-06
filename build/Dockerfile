FROM ubuntu:bionic

ARG packer_vesion
ENV PACKER_VERSION=${packer_version:-1.7.10}

ARG ansible_vesion
ENV ANSIBLE_VERSION=${packer_version:-2.9.27}

COPY . /tmp
RUN /tmp/scripts/setup.sh
