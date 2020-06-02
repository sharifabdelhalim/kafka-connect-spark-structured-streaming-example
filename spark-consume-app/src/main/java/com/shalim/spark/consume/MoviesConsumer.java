package com.shalim.spark.consume;

import org.apache.spark.sql.*;
import org.apache.spark.sql.streaming.StreamingQuery;
import org.apache.spark.sql.streaming.StreamingQueryException;
import org.apache.spark.sql.streaming.StreamingQueryListener;
import org.apache.spark.sql.streaming.Trigger;
import org.apache.spark.sql.types.StructType;
import org.apache.log4j.Logger;

import static org.apache.spark.sql.types.DataTypes.*;


public class MoviesConsumer {

    private static Logger logger = Logger.getLogger(MoviesConsumer.class);


    public static void main(String[] args) throws StreamingQueryException {

        StructType schema = new StructType()
                .add("id", IntegerType)
                .add("title", StringType)
                .add("description", StringType)
                .add("release_date", TimestampType)
                .add("genre_name", StringType);

        SparkSession session = SparkSession.builder().appName("MoviesConsumer").master("local").getOrCreate();

        session.streams().addListener(new StreamingQueryListener() {
            @Override
            public void onQueryProgress(QueryProgressEvent event) {
                logger.info("metrics:" + event.progress().toString());
            }

            @Override
            public void onQueryTerminated(QueryTerminatedEvent event) {
                logger.error("Application error:" + event.exception().toString());
            }

            @Override
            public void onQueryStarted(QueryStartedEvent event) {
                logger.info("Application has started");
            }
        });
        Dataset<Row> df = session.readStream()
                .format("kafka")
                .option("kafka.bootstrap.servers", "PLAINTEXT://kafka1:9092")
                // .option("kafka.bootstrap.servers", "PLAINTEXT_HOST://localhost:29092")
                .option("subscribe", "mysql-movies")
                .option("startingOffsets", "earliest")
                .load()
                .selectExpr("CAST(value AS STRING) as json");
        StreamingQuery query = df.select(functions.from_json(df.col("json"), schema).as("data")).select("data.*")
                .withColumn("release_date", functions.year(functions.col("release_date")))
                .withColumnRenamed("release_date", "release_year")
                .writeStream().outputMode("append").format("parquet").option("checkpointLocation", "./checkpoints").option("path", "./output")
                // .writeStream().outputMode("append").format("console")
                .trigger(Trigger.ProcessingTime("10 seconds"))
                .start();
        query.awaitTermination();
    }

}
