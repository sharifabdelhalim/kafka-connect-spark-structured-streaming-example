#!/bin/bash
echo "creating mysql-connector"
docker-compose exec connect bash -c 'curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://localhost:8083/connectors/ -d @/connect/mysql-source'
#removing kafka-clients-0.8 otherwise there are compatbility problems with spark structured streaming
docker-compose exec spark bash -c 'rm /usr/hadoop-3.0.0/share/hadoop/tools/lib/kafka-clients-0.8.2.1.jar'
echo "submitting spark job"
#docker-compose exec spark bash -c 'spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.1 --master local --class com.etl.challenge.ETLChallengeConsumer --conf spark.executor.extraJavaOptions=-Dlog4j.configuration=./log4j.properties --conf spark.driver.extraJavaOptions=-Dlog4j.configuration=./log4j.properties --files /app/conf/log4j.properties /app/target/ETLChallengeConsume-1.0-SNAPSHOT-jar-with-dependencies.jar'
docker-compose exec -d spark bash -c 'spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.1 --master local --class com.shalim.spark.consume.MoviesConsumer --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file:/app/conf/log4j.properties"  /app/target/MoviesConsumer-1.0-SNAPSHOT.jar'
echo "script end"