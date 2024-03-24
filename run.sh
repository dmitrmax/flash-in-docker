#! /bin/sh

USER_UID=$(id -u)

docker build -t flash-image  .
docker run -it --rm --user user:user -v /tmp/.X11-unix/:/tmp/.X11-unix -v /run/user/${USER_UID}/pulse:/run/user/1000/pulse --cap-add SYS_ADMIN flash-image
