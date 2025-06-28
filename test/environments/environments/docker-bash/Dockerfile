FROM bash:4.4
ADD ./tmp /
WORKDIR /home
RUN apk update
RUN apk add git
CMD ["./run-all-cases.sh", "/usr/local/bin/bash"]
