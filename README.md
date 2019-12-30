# Prestodb with MySQL and Kafka

PrestoDB, MySQL and Kafka in Docker.  Query your MySQL data and join it to Kafka data.

This repository includes docker-compose setup to join MySQL and Kafka data using Presto, along with some notes on how to load the data and perform the queries.  It is deliberately not fully automated to guide the user through performing this.

![img/Presto.png](img/Presto.png)

## Usage

Launch everything (Presto, Zookeeper, Kafka, MySQL):

```shell script
docker-compose up
```

Get access to MySQL to load some data (./data is mounted in /tmp/data):

```shell script
docker-compose exec mysql mysql -uuser -ppassword wheresalice
```

Load the data:

```mysql
source /tmp/data/load.sql
```

Load some data into Kafka:

```shell script
docker-compose exec kafka /bin/bash
curl -o kafka-tpch https://repo1.maven.org/maven2/de/softwareforge/kafka_tpch_0811/1.0/kafka_tpch_0811-1.0.sh
chmod 755 kafka-tpch
./kafka-tpch load --brokers localhost:9092 --prefix tpch. --tpch-type tiny
exit
```

Get access to PrestoDB:

```shell script
docker-compose exec presto presto
```

Query MySQL data in Presto:

```sql
use mysql.wheresalice;
show tables;
```

Query Kafka data in Presto:

```sql
use kafka.tpch;
SELECT _message FROM customer LIMIT 5;
SELECT sum(account_balance) FROM customer LIMIT 10;
```

Join the two together:

```sql
SELECT customer.account_balance, contacts.email FROM customer, mysql.wheresalice.contacts contacts WHERE customer.customer_key = contacts.customer_key;
```

View what's happening through the Presto UI: http://localhost:8080/ui/

## Known Issues

* The data in Kafka has to be in JSON or plain Avro to be able to parse it in Presto.  There is [not currently](https://github.com/prestodb/presto/issues/11354) any support for Confluent Avro with Schema Registry.

## Further Reading

* [Presto Kafka Connector](https://prestodb.io/docs/current/connector/kafka.html)