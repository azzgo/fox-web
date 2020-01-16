FROM busybox

RUN mkdir -p /tmp/assets

COPY ./build/  /tmp/assets

CMD ["sh", "-c", "echo fox-web assets here"]
