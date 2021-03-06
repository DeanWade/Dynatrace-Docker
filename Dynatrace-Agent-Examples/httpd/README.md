![Apache HTTPD Logo](https://github.com/Dynatrace/Dynatrace-Docker/blob/images/apache-httpd-logo.png)

# Dynatrace Agent Example: Apache HTTPD

This project contains exemplary integrations of the [Dynatrace Application Monitoring](http://www.dynatrace.com/docker) enterprise solution with a [Dockerized Apache HTTPD](https://hub.docker.com/_/httpd/) process for deep end-to-end application monitoring.

## How to install Dynatrace?

You can quickly bring up an entire Dockerized Dynatrace environment by using [Docker Compose](https://docs.docker.com/compose/) with the [provided `docker-compose.yml` file](https://github.com/Dynatrace/Dynatrace-Docker/blob/master/docker-compose.yml) like so:

```
DT_SERVER_LICENSE_KEY_FILE_URL=http://repo.internal/dtlicense.key \
docker-compose up
```

**Note**: the example runs an instance of type `dynatrace/server`. This image has been designed to run in low-traffic, resource-constrained **demo and trial environments**. Dynatrace does not support its use in production or pre-production grade environments of any kind.

### Licensing

In the example above, you have to let `DT_SERVER_LICENSE_KEY_FILE_URL` point to a valid Dynatrace License Key file. If you don't have a license yet, you can [obtain a Dynatrace Free Trial License here](http://bit.ly/dttrial-docker-github). However, you don't need to have your license file hosted by a server: if you can run a console, [Netcat](https://en.wikipedia.org/wiki/Netcat) can conveniently serve it for you on port `80` via `sudo nc -l 80 < dtlicense.key`.

## How to instrument a Dockerized Apache HTTPD process?

With the Dockerized Dynatrace environment running, we can now easily instrument an application process without having to alter that process' Docker image. Here is what an examplary integration in `run-container.sh` looks like:

<pre><code>#!/bin/bash
HTTPD_LOAD_MODULE="dtagent_module \${DTAGENT_ENV_AGENT_LIB64}"

echo "Starting Apache HTTPD - Example"
docker run --rm \
  --name httpd-example \
  <strong>--env DT_AGENT_NAME=httpd-agent</strong> \                                     # <strong>1)</strong>
  <strong>--volumes-from dtagent</strong> \                                              # <strong>2)</strong>
  <strong>--link dtcollector</strong> \                                                  # <strong>3)</strong>
  <strong>--link dtagent</strong> \                                                      # <strong>4)</strong>
  --publish-all \
  httpd \
  sh -c "<strong>\${DTAGENT_ENV_DT}/run-wsagent.sh</strong> && \                         # <strong>5)</strong>
         (<strong>echo LoadModule ${HTTPD_LOAD_MODULE} >> conf/httpd.conf</strong>) && \ # <strong>6)</strong>
         httpd-foreground"
</code></pre>

### Behind the Scenes

1) We set the agent's name to `httpd-agent`, thereby overriding the default value of `dtagent`.

2) We mount the agent installation directory from the `dtagent` container into the web server process' container via `--volumes-from dtagent`.

3) **Convenience**: We link the web server process' container against the `dtcollector` container via `--link dtcollector`. This way, we inherit the other container's environment so that we can auto-discover the location of the Dynatrace Collector in Docker.

4) **Convenience**: We link the web server process' container against the `dtagent` container via `--link dtagent`. This way, we inherit the other container's environment variables `DTAGENT_ENV_DT` and `DTAGENT_ENV_AGENT_LIB64` and can thus quickly deduce a `LoadModule` declaration without having to know much about the environment.

5) We run the Dynatrace Web Server Agent process by invoking `run-wsagent.sh`, which has been shared by the `dtagent` container in step **1)**. This process relays application monitoring data from the web server process to a Dynatrace Collector.

6) We place a `LoadModule` declaration inside Apache's `httpd.conf` before we invoke the actual web server process ([see here for the original Dockerfile](https://github.com/docker-library/httpd/blob/1f1f7d39d5fe5aebeedea6872786b4e3ce0ebcc9/2.4/Dockerfile)).

## Additional Information

See the following Dockerized Dynatrace components and examples for more information:

- [Dockerized Dynatrace Agent](https://github.com/Dynatrace/Dynatrace-Docker/tree/master/Dynatrace-Agent) and [Examples](https://github.com/Dynatrace/Dynatrace-Docker/tree/master/Dynatrace-Agent-Examples)
- [Dockerized Dynatrace Collector](https://github.com/Dynatrace/Dynatrace-Docker/tree/master/Dynatrace-Collector)
- [Dockerized Dynatrace Server](https://github.com/Dynatrace/Dynatrace-Docker/tree/master/Dynatrace-Server)

## Problems? Questions? Suggestions?

This offering is [Dynatrace Community Supported](https://community.dynatrace.com/community/display/DL/Support+Levels#SupportLevels-Communitysupported/NotSupportedbyDynatrace(providedbyacommunitymember)). Feel free to share any problems, questions and suggestions with your peers on the Dynatrace Community's [Application Monitoring & UEM Forum](https://answers.dynatrace.com/spaces/146/index.html).

## License

Licensed under the MIT License. See the [LICENSE](https://github.com/Dynatrace/Dynatrace-Docker/blob/master/Dynatrace-Agent-Examples/httpd/LICENSE) file for details.
[![analytics](https://www.google-analytics.com/collect?v=1&t=pageview&_s=1&dl=https%3A%2F%2Fgithub.com%2FdynaTrace&dp=%2FDynatrace-Docker%2FDynatrace-WebServer-Agent-Examples%2Fhttpd&dt=Dynatrace-Docker%2FDynatrace-WebServer-Agent-Examples%2Fhttpd&_u=Dynatrace~&cid=github.com%2FdynaTrace&tid=UA-54510554-5&aip=1)]()