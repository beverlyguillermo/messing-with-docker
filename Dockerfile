FROM centos:7
MAINTAINER beverly
ENV container docker
RUN echo -n 'exclude=postgresql*' >> /etc/yum.repos.d/CentOS-Base.repo
RUN yum localinstall -y http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN yum install -y epel-release
RUN yum -y update
RUN yum groupinstall -y "development"

# For postgres
RUN yum -y install postgresql94-devel libpqxx-devel

# For other rails stuff
RUN yum -y install libxml2-devel libxslt1-devel libcurl-devel libyaml-devel readline-devel zlib-devel libffi-devel openssl-devel sqlite-devel

# For capybara-webkit
RUN yum -y install qtwebkit-devel xvfb

# For a JS runtime
RUN yum -y install nodejs

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm install ruby-2.2.3
RUN /bin/bash -l -c /usr/local/rvm/bin/rvm use --default ruby-2.2.3

# Set up working directory
RUN mkdir /myapp
WORKDIR /myapp

ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "rvm use ruby-2.2.3 && gem install bundler && bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config && bundle install"
ADD . /myapp
