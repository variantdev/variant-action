FROM alpine:3.8

LABEL "com.github.actions.name"="Run Variant Task"
LABEL "com.github.actions.description"="Run Variant task defined in your Variantfile https://github.com/mumoshu/variant"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="orange"

# Install all packages as root
USER root

# Install the cloudposse alpine repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.8/vendor" >> /etc/apk/repositories

RUN apk add --update --no-cache bash curl \
  slack-notifier@cloudposse \
  github-commenter@cloudposse

RUN cd /usr/local/bin && \
  curl -L https://github.com/mumoshu/variant/releases/download/v0.21.2/variant_0.21.2_linux_amd64.tar.gz | tar zxvf - && \
  rm README.md

CMD [ "/usr/local/bin/variant" ]
