FROM spark:latest

WORKDIR /opt/spark

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

# EXPOSE 8080 7077 6066

#creates the log dir (if not already created) and creates log files as empty files
RUN mkdir -p $SPARK_LOG_DIR && \
touch $SPARK_MASTER_LOG && \
touch $SPARK_WORKER_LOG && \
ln -sf /dev/stdout $SPARK_MASTER_LOG && \
ln -sf /dev/stdout $SPARK_WORKER_LOG

COPY start-spark.sh /

USER root

CMD ["bash","/start-spark.sh"]