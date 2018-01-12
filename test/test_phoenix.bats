
@test "psql returns the correct result" {
  run docker run  -i --net vnet -e HBASE_ZOOKEEPER_QUORUM=zookeeper-1.vnet:2181 --volumes-from regionserver-1 smizy/apache-phoenix:${VERSION}-alpine psql.py examples/WEB_STAT.sql examples/WEB_STAT.csv examples/WEB_STAT_QUERIES.sql 2>/dev/null

  [ $status -eq 0 ]
  
  get_result="${lines[4]}"

  n=$(( ${#lines[*]} -1 ))
  for i in $(seq 0 $n); do
    echo "$i:******** ${lines[$i]}"
  done

  val="$(IFS=' '; set -- ${get_result}; echo $4)"

  echo "[val = $val]"
  [ "${val}" = "39" ]
}

@test "queryserver client returns the correct result" {
  run docker run  -i --net vnet -e HBASE_ZOOKEEPER_QUORUM=zookeeper-1.vnet:2181  smizy/apache-phoenix:${VERSION}-alpine bin/sqlline-thin.py http://queryserver-1.vnet:8765 <<EOD
!set outputformat csv
SELECT * FROM WEB_STAT;
EOD

  [ $status -eq 0 ]
  
  get_result="${lines[15]}"

  n=$(( ${#lines[*]} -1 ))
  for i in $(seq 0 $n); do
    echo "$i:******** ${lines[$i]}"
  done

  val="${get_result}"

  echo "[val = $val]"
  [ "${val}" = "'EU','Apple.com','Mac','2013-01-01','35','22','34'" ]
}

