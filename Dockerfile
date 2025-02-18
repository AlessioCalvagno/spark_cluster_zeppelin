FROM spark:latest

#switch to user root for workaround with zeppelin: zeppelin asks worker to create subdirectories under
#/opt/spark/work, but this dir has root ownership.
#TODO: change directory ownership/permission to 'spark' user (read and write access).
USER root

WORKDIR /opt/spark



# Install Python 3.9
RUN apt-get update && apt-get install -y python3.9 python3.9-venv python3.9-dev

# Set env vars to use Python3.9 and not system default python3
ENV PYSPARK_PYTHON=/usr/bin/python3.9 \
    PYSPARK_DRIVER_PYTHON=/usr/bin/python3.9

#https://spark.apache.org/docs/latest/spark-standalone.html
#https://dev.to/mvillarrealb/creating-a-spark-standalone-cluster-with-docker-and-docker-compose-2021-update-6l4

ENV SPARK_MASTER_PORT=7077 \
SPARK_MASTER_WEBUI_PORT=8080 \
SPARK_LOG_DIR=/opt/spark/logs \
SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
SPARK_WORKER_WEBUI_PORT=8081 \
SPARK_MASTER="spark://spark-master:7077" \
SPARK_WORKLOAD="master"
# SPARK_WORKER_PORT=7000

#creates the log dir (if not already created) and creates log files as empty files
RUN mkdir -p $SPARK_LOG_DIR && \
touch $SPARK_MASTER_LOG && \
touch $SPARK_WORKER_LOG && \
ln -sf /dev/stdout $SPARK_MASTER_LOG && \
ln -sf /dev/stdout $SPARK_WORKER_LOG

COPY start-spark.sh /

CMD ["bash","/start-spark.sh"]