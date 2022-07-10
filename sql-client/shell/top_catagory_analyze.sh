#!/usr/bin/env bash
#source /etc/profile
## FLINK_HOMR is option
#FLINK_HOME=../embedded-flink

SQL_CLIENT_HOME=../sql-client
SQL_SCRIPT_FILE=../flink-sql/top_catagory_analyze

$FLINK_HOME/bin/sql-client.sh embedded \
  -l $SQL_CLIENT_HOME/lib \
  -i $SQL_SCRIPT_FILE/session_init.sql \
  -f $SQL_SCRIPT_FILE/main.sql
