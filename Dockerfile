ARG version=latest
FROM hashicorp/terraform:$version as terraform

FROM alpine:latest
COPY --from=terraform /bin/terraform /bin/
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN addgroup -g $GROUP_ID deploy && \
    adduser -u $USER_ID -G deploy -D deploy
USER deploy
CMD ["/bin/sh"]
