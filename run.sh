#!/bin/bash

java -Xmx768M \
  -XX:MaxPermSize=256M \
  -Drundeck.jetty.connector.forwarded=true \
  -Dserver.http.host=0.0.0.0 \
  -Dserver.hostname=${SERVER_NAME} \
  -Dserver.http.port=${SERVER_PORT:-4440} \
  -jar $RUNDECK_JARDIR/app.jar --basedir $RUNDECK_BASEDIR
