# Gitlab Runner Hetzner

[DockerHub Image](https://hub.docker.com/r/szevez/gitlab-runner-hetzner)

## Versions

- gitlab/gitlab-runner - v16.4.0
- docker-machine-driver-hetzner - 5.0.1

## Usage

Make use of this custom gitlab-runner-hetzner which uses [docker-machine-driver-hetzner](https://github.com/JonasProgrammer/docker-machine-driver-hetzner)

```yaml
version: '2'
services:
  hetzner-runner:
    image: szevez/gitlab-runner-hetzner:latest
    mem_limit: 128mb
    memswap_limit: 256mb
    volumes:
      - "./hetzner_config:/etc/gitlab-runner"
    restart: always
```

Example gitlab runner config.toml

```toml
concurrent = 10
log_level = "info"
check_interval = 0
[[runners]]
  name = "hetzner-autoscale-test"
  url = "https://gitlab.com/"
  token = "$GITLAB_CI_TOKEN"
  executor = "docker+machine"
  [runners.cache]
  [runners.docker]
    tls_verify = false
    image = "docker:19.03-dind"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/certs/client", "/cache"]
    shm_size = 536870912
    pull_policy = "if-not-present"
  [runners.machine]
    IdleCount = 0
    IdleTime = 1200
    MachineDriver = "hetzner"
    MachineName = "runner-%s"
    MachineOptions = [
        "hetzner-api-token=$HETZNER_API_TOKEN",
        "hetzner-image=ubuntu-20.04",
        "hetzner-server-type=cpx41",
        "engine-install-url=https://releases.rancher.com/install-docker/19.03.9.sh" # Related https://github.com/docker/machine/issues/4858
    ]
    [[runners.machine.autoscaling]]
      Periods = ["* * 8-18 * * mon-fri *"]
      IdleCount = 2
      IdleTime = 1200
      Timezone = "UTC"
```
