Rundeck docker image
=======

Rundeck image on the OpenJDK7 JRE with file-based data storage

    docker run -p 4440:4440 --rm -it -v rundeck_data:/opt/rundeck/basedir -e SERVER_NAME=<your server name> rundeck

User interface will be accessable on http://SERVER_NAME:4440


Required parameters
  - `SERVER_NAME` - Server name
