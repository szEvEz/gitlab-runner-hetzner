FROM ubuntu as builder

ARG DMD_HETZNER_VERSION=5.0.1

RUN apt-get update \
 && apt-get install -y wget tar

WORKDIR /build

RUN wget https://github.com/JonasProgrammer/docker-machine-driver-hetzner/releases/download/$DMD_HETZNER_VERSION/docker-machine-driver-hetzner_${DMD_HETZNER_VERSION}_linux_amd64.tar.gz \
 && tar xf docker-machine-driver-hetzner_${DMD_HETZNER_VERSION}_linux_amd64.tar.gz \
 && chmod +x docker-machine-driver-hetzner

FROM gitlab/gitlab-runner:v16.4.0
COPY --from=builder /build/docker-machine-driver-hetzner /usr/bin
