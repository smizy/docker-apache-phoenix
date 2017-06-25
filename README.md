# docker-phoenix

[![](https://images.microbadger.com/badges/image/smizy/apache-phoenix:4.11-alpine.svg)](http://microbadger.com/images/smizy/apache-phoenix:4.11-alpine "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/smizy/apache-phoenix:4.11-alpine.svg)](http://microbadger.com/images/smizy/apache-phoenix:4.11-alpine "Get your own version badge on microbadger.com")
[![CircleCI](https://circleci.com/gh/smizy/docker-apache-phoenix.svg?style=svg&circle-token=8171bd548172f815e994704c0c7f23ac3447371d)](https://circleci.com/gh/smizy/docker-apache-phoenix)

Apache Phoenix docker image based on alpine

## Small setup

```
# load default env as needed
eval $(docker-machine env default)

# network 
docker network create vnet

# hbase+phoenix startup
docker-compose up -d

# tail logs for a while
docker-compose logs -f

# check ps
docker-compose ps
    Name                   Command               State                  Ports                
---------------------------------------------------------------------------------------------
datanode-1       entrypoint.sh datanode           Up      50010/tcp, 50020/tcp, 50075/tcp     
hmaster-1        entrypoint.sh hmaster-1          Up      16000/tcp, 0.0.0.0:32781->16010/tcp 
namenode-1       entrypoint.sh namenode-1         Up      0.0.0.0:32780->50070/tcp, 8020/tcp  
regionserver-1   entrypoint.sh regionserver       Up      16020/tcp, 16030/tcp                
zookeeper-1      entrypoint.sh -server 1 1 vnet   Up      2181/tcp, 2888/tcp, 3888/tcp

# Try Getting Started (http://phoenix.apache.org/installation.html)

docker-compose exec regionserver-1 sh
$ psql.py zookeeper-1.vnet examples/STOCK_SYMBOL.sql examples/STOCK_SYMBOL.csv
no rows upserted
Time: 0.01 sec(s)

1 row upserted
Time: 0.044 sec(s)

SYMBOL                                   COMPANY                                  
---------------------------------------- ---------------------------------------- 
CRM                                      SalesForce.com                           
Time: 0.044 sec(s)

csv columns from database.
CSV Upsert complete. 9 rows upserted
Time: 0.02 sec(s)

$ sqlline.py zookeeper-1.vnet
Connected to: Phoenix (version 4.11)
Driver: PhoenixEmbeddedDriver (version 4.11)
Autocommit status: true
Transaction isolation: TRANSACTION_READ_COMMITTED
Building list of tables and columns for tab-completion (set fastconnect to true to skip)...
88/88 (100%) Done
Done
sqlline version 1.2.0
0: jdbc:phoenix:zookeeper-1.vnet>
0: jdbc:phoenix:zookeeper-1.vnet> !table
0: jdbc:phoenix:zookeeper-1.vnet> select * from STOCK_SYMBOL;
+---------+-----------------------+
| SYMBOL  |        COMPANY        |
+---------+-----------------------+
| AAPL    | APPLE Inc.            |
| CRM     | SALESFORCE            |
| GOOG    | Google                |
| HOG     | Harlet-Davidson Inc.  |
| HPQ     | Hewlett Packard       |
| INTC    | Intel                 |
| MSFT    | Microsoft             |
| WAG     | Walgreens             |
| WMT     | Walmart               |
+---------+-----------------------+
9 rows selected (0.067 seconds)

0: jdbc:phoenix:zookeeper-1.vnet> !exit

# hbase/phoenix shutdown  
docker-compose stop

# cleanup container
docker-compose rm -v
```