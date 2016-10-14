FROM centos:centos7.2.1511
MAINTAINER Sam Chen <chenxsan@gmail.com>

RUN yum update -y && yum clean all
RUN yum install -y wget && yum clean all
RUN wget http://erlang.org/download/otp_src_19.1.tar.gz
RUN yum install -y gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git && yum clean all
RUN tar zxvf otp_src_19.1.tar.gz
RUN cd otp_src_19.1 && ./otp_build autoconf && ./configure && make && make install

# Set the locale (en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Build Elixir
ENV ELIXIR_VERSION 1.3.4
WORKDIR /home
RUN git clone https://github.com/elixir-lang/elixir.git
WORKDIR /home/elixir
RUN git checkout refs/tags/v${ELIXIR_VERSION}
RUN make clean install
RUN export PATH="$PATH:/home/elixir/bin"

# Install Hex
RUN mix local.hex --force

# Install Rebar
RUN mix local.rebar --force

# Install Node.js
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs

# Install Yarn
RUN npm install -g yarn