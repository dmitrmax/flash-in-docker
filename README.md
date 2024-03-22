# Build & run it with following commands

    docker build -t flash-image  .

    docker run -it --rm --user user:user -v /tmp/.X11-unix/:/tmp/.X11-unix  --cap-add SYS_ADMIN flash-image
