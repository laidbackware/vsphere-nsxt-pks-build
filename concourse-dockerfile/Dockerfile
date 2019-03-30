FROM alpine:3.9.2

ENV ANSIBLE_VERSION=2.7.9

RUN set -xe \
    && echo "****** Install system dependencies ******" \
    && apk add --no-cache --progress python3 openssl \
		ca-certificates git openssh sshpass tar gzip sed gawk bash \
	&& apk --update add --virtual build-dependencies \
		python3-dev libffi-dev openssl-dev build-base \
	\
	&& echo "****** Install ansible and python dependencies ******" \
    && pip3 install --upgrade pip \
	&& pip3 install ansible==${ANSIBLE_VERSION} boto3 pyvmomi requests \
    \
    && echo "****** Remove unused system librabies ******" \
	&& apk del build-dependencies \
	&& rm -rf /var/cache/apk/* 

ADD VMware-ovftool-*.bundle /tmp/
RUN chmod +x /tmp/VMware-ovftool-*.bundle && echo -e "/w00t\n" >> /tmp/answer \
	/tmp/VMware-ovftool-4.2.0-4586971-lin.x86_64.bundle --eulas-agreed --required --console < /tmp/answer \
	&& rm /tmp/VMware-ovftool-*.bundle

