# This is a copy of the Dockerfile from mozilla/docker-sbt
# https://github.com/mozilla/docker-sbt/blob/main/Dockerfile
ARG OPENJDK_TAG
FROM openjdk:${OPENJDK_TAG}-jdk

# Install sbt
RUN \
  SBT_VERSION=1.2.7 && \
  mkdir /working/ && \
  cd /working/ && \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get -y --no-install-recommends install sbt && \
  cd && \
  rm -r /working/ && \
  sbt sbtVersion

RUN groupadd -r sbt_user && useradd -r --create-home -g sbt_user sbt_user
COPY . /usr/src/science_parse
WORKDIR /usr/src/science_parse
RUN chown -R sbt_user:sbt_user /usr/src/science_parse

USER sbt_user

RUN sbt server/assembly



