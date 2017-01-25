FROM amazonlinux
MAINTAINER 'Jussi Heinonen<jussi.heinonen@ft.com>'

RUN yum clean all && yum install -y ruby wget which git cronie
RUN curl https://bootstrap.pypa.io/get-pip.py | python && pip install awscli boto
RUN gem install puppet --no-rdoc --no-ri

CMD /bin/bash
