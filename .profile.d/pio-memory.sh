#!/usr/bin/env bash

function already_has_memory_opts() {
  echo ${@:-} | grep --extended-regexp '(--executor-memory|--driver-memory)'
}

limit=$(ulimit -u)
case $limit in
256)   # 512MB (Free, Hobby, Standard-1X)
  default_spark_opts="--driver-memory 384m"
  ;;
512)   # 1024MB (Standard-2X, Private-S)
  default_spark_opts="--driver-memory 768m"
  ;;
16384) # 2560MB (Performance-M, Private-M)
  default_spark_opts="--driver-memory 2024m"
  ;;
32768) # 14GB (Performance-L, Private-L)
  default_spark_opts="--driver-memory 13g"
  ;;
*)
  default_spark_opts="--driver-memory 384m"
  ;;
esac


PIO_SPARK_OPTS=${PIO_SPARK_OPTS:-}

if [ ! "$(already_has_memory_opts $PIO_SPARK_OPTS)" ]
then
  export PIO_SPARK_OPTS="$default_spark_opts $PIO_SPARK_OPTS"
  echo "Autoset Spark memory params for web process: $PIO_SPARK_OPTS"
fi

PIO_TRAIN_SPARK_OPTS=${PIO_TRAIN_SPARK_OPTS:-}

if [ ! "$(already_has_memory_opts $PIO_TRAIN_SPARK_OPTS)" ]
then
  export PIO_TRAIN_SPARK_OPTS="$default_spark_opts $PIO_TRAIN_SPARK_OPTS"
  echo "Autoset Spark memory params for training: $PIO_TRAIN_SPARK_OPTS"
fi
