FROM centos
MAINTAINER 'Jussi Heinonen<jussi.heinonen@ft.com>'

RUN yum install -y ruby wget which
RUN curl https://bootstrap.pypa.io/get-pip.py | python && pip install awscli
RUN gem install puppet --no-rdoc --no-ri

CMD /bin/bash
