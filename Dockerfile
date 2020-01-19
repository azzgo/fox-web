FROM busybox

RUN mkdir -p /tmp/assets

COPY ./build/  /tmp/assets

