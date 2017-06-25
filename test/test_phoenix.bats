
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

