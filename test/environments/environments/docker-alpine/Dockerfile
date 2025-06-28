FROM alpine:3.20.3
ADD ./tmp /
WORKDIR /home
RUN apk update
RUN apk add git
CMD ["./run-all-cases.sh"]
