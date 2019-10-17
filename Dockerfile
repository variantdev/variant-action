FROM alpine:3.10

LABEL "repository"="http://github.com/variantdev/variant-action"
LABEL "homepage"="http://github.com/variantdev/variant-action"
LABEL "maintainer"="Yusuke KUOKA <ykuoka@gmail.com>"

# Install all packages as root
USER root

# Install the cloudposse alpine repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.8/vendor" >> /etc/apk/repositories

RUN apk add --update --no-cache bash curl git jq \
  docker-compose docker-cli \
  slack-notifier@cloudposse \
  github-commenter@cloudposse

ENV VARIANT_VERSION 0.36.4

RUN cd /usr/local/bin && \
  curl -L https://github.com/mumoshu/variant/releases/download/v${VARIANT_VERSION}/variant_{$VARIANT_VERSION}_linux_amd64.tar.gz | tar zxvf - && \
  rm README.md

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
