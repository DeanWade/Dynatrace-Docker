#!/bin/bash
DT_AGENT_NAME=${JAVA_DT_AGENT_NAME:-"java-agent"}
DT_AGENT_PATH="-agentpath:\${DTAGENT_ENV_AGENT_LIB64}=name=${DT_AGENT_NAME},collector=\${DTCOLLECTOR_ENV_HOST_NAME}"

echo "Starting Java - Example"
docker run --rm \
  --name java-example \
  --volumes-from dtagent \
  --link dtagent \
  --link dtcollector \
  dynatrace/java-example \
  sh -c "java ${DT_AGENT_PATH} JavaTest"