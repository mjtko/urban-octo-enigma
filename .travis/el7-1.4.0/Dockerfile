FROM alces/clusterware-el7:1.4.0
MAINTAINER Alces Software Ltd <support@alces-software.com>

ARG --description="tree under test" treeish
ARG --description="repo under test" repo_slug

RUN rm -rf /opt/clusterware/var/lib/gridware/repos/base/pkg
RUN /opt/clusterware/opt/git/bin/git clone https://github.com/$repo_slug /opt/clusterware/var/lib/gridware/repos/base/pkg
RUN cd /opt/clusterware/var/lib/gridware/repos/base/pkg && /opt/clusterware/opt/git/bin/git checkout ${treeish} || true

CMD ["/bin/bash"]
