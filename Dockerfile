FROM centos:7
RUN yum -y install sudo rpm-build && yum -y install make && \
    yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm && yum -y install centos-release-scl && \
    yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ devtoolset-8-binutils && \
    echo "source /opt/rh/devtoolset-8/enable" >> /etc/profile && echo "source /opt/rh/devtoolset-8/enable" >> ~/.bashrc && source ~/.bashrc && \
    yum -y install git vim openssl-devel bzip2-devel libffi-devel sqlite-devel zlib-devel && \
    debuginfo-install -y glibc && \
    yum install -y rh-python36 && echo "source /opt/rh/rh-python36/enable" >> ~/.bashrc && source ~/.bashrc && \
    curl -fsSL https://rpm.nodesource.com/setup_10.x | bash - && yum -y install nodejs && \
    npm install -g yarn electron-builder

RUN yum install -y kde-l10n-Chinese && yum reinstall -y glibc-common && localedef -c -f GB18030 -i zh_CN zh_CN.GB18030
RUN yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm && yum -y install cmake3 && ln -s /usr/bin/cmake3 /usr/bin/cmake
RUN pip3 install pipenv && pip3 install -q compdb
RUN yum -y clean all

ENV PATH=/opt/rh/devtoolset-8/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=en_US.UTF-8
ENV BASH_ENV=~/.bashrc  \
    ENV=~/.bashrc  \
    PROMPT_COMMAND="source ~/.bashrc"
