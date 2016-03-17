FROM alces/clusterware-centos7:1.4.0
MAINTAINER Alces Software Ltd <support@alces-software.com>

RUN rm -rf /opt/clusterware/var/lib/gridware/repos/base/pkg
RUN /opt/clusterware/opt/git/bin/git clone https://github.com/alces-software/packager-base /opt/clusterware/var/lib/gridware/repos/base/pkg
RUN cd /opt/clusterware/var/lib/gridware/repos/base/pkg && /opt/clusterware/opt/git/bin/git checkout ${TRAVIS_COMMIT}

CMD ["/bin/bash"]
