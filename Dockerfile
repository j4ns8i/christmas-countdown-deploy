ARG version=latest
FROM hashicorp/terraform:$version as terraform

FROM alpine:latest
COPY --from=terraform /bin/terraform /bin/
RUN adduser -D deploy
USER deploy
CMD ["/bin/sh"]
