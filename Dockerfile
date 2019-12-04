#
# This is a Spark dockerfile
# https://medium.com/@marcovillarreal_40011/creating-a-spark-standalone-cluster-with-docker-and-docker-compose-ba9d743a157f
# just use as is from original author...  https://github.com/mvillarrealb/docker-spark-cluster
#

FROM java:8-jdk-alpine

ENV DAEMON_RUN=true
ENV SPARK_VERSION=2.3.1
ENV HADOOP_VERSION=2.7
ENV SCALA_VERSION=2.12.4
ENV SCALA_HOME=/usr/share/scala

RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache bash curl jq && \
    cd "/tmp" && \
    wget --no-verbose "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/"*
    
#Scala instalation
RUN export PATH="/usr/local/sbt/bin:$PATH" &&  apk update && apk add ca-certificates wget tar && mkdir -p "/usr/local/sbt" && wget -qO - --no-check-certificate "https://cocl.us/sbt-0.13.16.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && sbt sbtVersion

RUN apk add --no-cache python3

RUN wget --no-verbose http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz