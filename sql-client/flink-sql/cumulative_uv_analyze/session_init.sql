--session init conf --
-- SET 'execution.savepoint.path' = '/tmp/flink-savepoints/savepoint-cca7bc-bb1e257f0dab'
SET
'execution.checkpointing.interval' = '3s';
SET
'execution.runtime-mode' = 'streaming';
SET
'parallelism.default' = '5';
SET
'pipeline.auto-watermark-interval' = '200';
SET
'pipeline.max-parallelism' = '10';
SET
'pipeline.name' = 'kafka-and-mysql-to-es';


--connector--
--商品日志行为表
CREATE TABLE user_behavior
(
    user_id     BIGINT,
    item_id     BIGINT,
    category_id BIGINT,
    behavior    STRING,
    ts          TIMESTAMP(3),
    proctime AS PROCTIME(),                      -- generates processing-time attribute using computed column
    WATERMARK FOR ts AS ts - INTERVAL '5' SECOND -- defines watermark on ts column, marks ts as event-time attribute
) WITH (
      'connector' = 'kafka', -- using kafka connector
      'topic' = 'user_behavior', -- kafka topic
      'scan.startup.mode' = 'earliest-offset', -- reading from the beginning
      'properties.bootstrap.servers' = 'kafka:9094', -- kafka broker address
      'format' = 'json' -- the data format is json
      );

-- sink --

CREATE TABLE cumulative_uv
(
    date_str STRING,
    time_str STRING,
    uv       BIGINT,
    PRIMARY KEY (date_str, time_str) NOT ENFORCED
) WITH (
      'connector' = 'elasticsearch-7',
      'hosts' = 'http://elasticsearch:9200',
      'index' = 'cumulative_uv'
      );




