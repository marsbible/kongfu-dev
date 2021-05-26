FROM centos:7
RUN yum -y install sudo rpm-build && yum -y install make && \
    yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm && yum -y install centos-release-scl && \
    yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ devtoolset-8-binutils && \
    echo "if [ \"\$(gcc -dumpversion 2> /dev/null)\" = \"\" ]; then " >> ~/.bashrc && echo "source /opt/rh/devtoolset-8/enable" >> ~/.bashrc && \
    echo "fi" >> ~/.bashrc && source ~/.bashrc && \
    yum -y install git vim openssl-devel bzip2-devel libffi-devel sqlite-devel zlib-devel && \
    debuginfo-install -y glibc && \
    yum install -y rh-python36 && echo "if [ \"\$(python3.6 --version 2> /dev/null)\" != \"Python 3.6.12\" ]; then " >> ~/.bashrc && \
    echo "source /opt/rh/rh-python36/enable" >> ~/.bashrc && echo "fi" >> ~/.bashrc && source ~/.bashrc && \
    curl -fsSL https://rpm.nodesource.com/setup_10.x | bash - && yum -y install nodejs && \
    npm install -g yarn electron-builder

RUN yum install -y kde-l10n-Chinese && yum reinstall -y glibc-common && localedef -c -f GB18030 -i zh_CN zh_CN.GB18030 && \
    yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm && \
    yum -y install cmake3 && ln -s /usr/bin/cmake3 /usr/bin/cmake && \
    pip3 install pipenv && pip3 install -q compdb && \
    yum -y clean all

RUN cd /root && curl -fsSL https://ftp.gnu.org/gnu/glibc/glibc-2.20.tar.gz  | tar xzf - 
RUN cd /root && curl -fsSL https://github.com/clangd/clangd/releases/download/12.0.0/clangd-linux-12.0.0.zip -o clangd-linux-12.0.0.zip 
RUN cd /root && curl -fsSL https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/patchelf-0.12-1.el7.x86_64.rpm -o patchelf.rpm \
    && rpm -ivh patchelf.rpm

RUN cd /root/glibc-2.20 && source ~/.bashrc && mkdir build && cd build && ../configure --prefix=/opt/glibc-2.20 && make && make install \
    && unzip /root/clangd-linux-12.0.0.zip -d /usr/local \
    && ln -s /usr/local/clangd_12.0.0/bin/clangd  /usr/bin/clangd \
    && patchelf --set-interpreter /opt/glibc-2.20/lib/ld-linux-x86-64.so.2 --set-rpath /opt/glibc-2.20/lib:/usr/lib64 /usr/local/clangd_12.0.0/bin/clangd \
    && rm -fr /root/*

RUN npm config set registry https://registry.npm.taobao.org && \
    npm config set puppeteer_download_host https://npm.taobao.org/mirrors && \
    npm config set electron_mirror https://npm.taobao.org/mirrors/electron/ && \
    npm config set sass-binary-site https://npm.taobao.org/mirrors/node-sass && \
    npm config set npm_config_disturl=https://npm.taobao.org/mirrors/atom-shell

ENV LANG=en_US.UTF-8
ENV BASH_ENV=~/.bashrc  \
    ENV=~/.bashrc  \
    PROMPT_COMMAND="source ~/.bashrc"
