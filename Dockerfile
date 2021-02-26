ARG OPENJDK_TAG
FROM openjdk:${OPENJDK_TAG}-jre

RUN groupadd -r java_user && useradd -r --create-home -g java_user java_user
WORKDIR /usr/src/science_parse
RUN chown -R java_user:java_user /usr/src/science_parse

USER java_user

ARG SP_VERSION
ARG JAVA_MEMORY
ENV SP_VERSION $SP_VERSION

COPY --from=ucrel/ucrel-science-parse-builder:3.0.1 /usr/src/science_parse/server/target/scala-2.12/science-parse-server-assembly-$SP_VERSION.jar ./science-parse-server-assembly-$SP_VERSION.jar

RUN java -Xmx${JAVA_MEMORY}g -jar ./science-parse-server-assembly-$SP_VERSION.jar --downloadModelOnly

ENV JAVA_MEMORY $JAVA_MEMORY

EXPOSE 8080

CMD java -Xmx${JAVA_MEMORY}g -jar science-parse-server-assembly-$SP_VERSION.jar