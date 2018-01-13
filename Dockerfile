FROM alpine
RUN apk add --no-cache --update bash curl bc coreutils && rm -rf /var/cache/apk/*
COPY test-runner.sh /bin
CMD ["/bin/test-runner.sh"]
