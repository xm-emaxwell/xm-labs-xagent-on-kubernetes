FROM centos:latest

COPY xmatters.com.repo /etc/yum.repos.d/xmatters.com.repo

RUN yum -y install xmatters-xa && \
    touch /etc/xmatters/xa/auth.conf && \
    ln -sf /dev/stdout /var/log/xmatters/xmatters-xa/agent-communication-xmatters.log

COPY docker_entrypoint.sh /docker_entrypoint.sh

ENV FRIENDLY_NAME=""
ENV WEBSOCKET_HOST=""
ENV WEBSOCKET_SECRET=""
ENV OWNER_API_KEY=""

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

ENTRYPOINT ["/docker_entrypoint.sh"]
CMD ["start"]
