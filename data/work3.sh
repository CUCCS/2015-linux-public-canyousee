#!/bin/bash
#    统计访问来源主机TOP 100和分别对应出现的总次数   -a
#    统计访问来源主机TOP 100 IP和分别对应出现的总次数 -b
#    统计最频繁被访问的URL TOP 100 -c
#    统计不同响应状态码的出现次数和对应百分比 -d
#    分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数 -e
#    给定URL输出TOP 100访问来源主机 -f URL
sum=0
all=0
if [[ $1 == "-a" ]];then
          echo "访问来源主机TOP 100和分别对应出现的总次数"
          awk -F '\t' '{a[$1]++} END {for( i in a){print i ,a[i] |"sort -nr -k 2 -o 1.txt"}}' web_log.tsv
          cat 1.txt | head -n 100
        fi

if [[ $1 == "-b" ]];then
          echo "访问来源主机TOP 100 IP和分别对应出现的总次数"
          egrep '^[[:digit:]]{1,3}\.' web_log.tsv >2.txt
          awk -F '\t' '{a[$1]++} END {for( i in a){print i ,a[i] |"sort -nr -k 2 -o 3.txt"}}' 2.txt
          cat 3.txt | head -n 100
        fi

if [[ $1 == "-c" ]];then
    echo "最频繁被访问的URL"
    awk -F '\t' '{a[$5]++} END {for( i in a){print i, a[i]  |"sort -nr -k 2 -o 4.txt"}}' web_log.tsv
    cat 4.txt | head -n 100
fi

if [[ $1 == "-d" ]];then
  awk -F '\t' '{a[$6]++} END {for( i in a){print i, a[i] |"sort -nr -k 2 -o 5.txt"}}' web_log.tsv
  file=$(awk -F '\t' '{print $2}' 5.txt)
  for ff in $file ;
  do
    sum=$[$sum+1]
  done
  file=$(awk -F '\t' '{print $2}' 5.txt)
  aa=""
  echo "不同响应状态码的出现次数和对应百分比"
  for fin in $file;
  do
            all=$[$all+1]
            aa=$(awk -F '\t' 'NR=='$all'' '{print$1}' 5.txt)
            echo "$aa\t$fin"
            awk 'BEGIN{printf "%.2f\n",'$fin'/'$sum'}'
  done
        fi

if [[ $1 == "-e" ]];then
      echo "统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
      cat web_log.tsv |awk -F '\t' '{print $6,$5}' | grep '403 ' | sort|uniq -c |sort -k 1 -nr|head -n 10
      echo "\n"
      cat web_log.tsv |awk -F '\t' '{print $6,$5}' | grep '404 ' | sort|uniq -c |sort -k 1 -nr|head -n 10
        fi

if [[ $1 == "-f" ]];then
      echo "给定URL输出TOP 100访问来源主机"
      url=$2
      grep "$url" |awk -F '\t' '{print $1}' web_log.tsv |sort|uniq -c |sort -nr|head -n 10
         fi

if [[ $1 == "-h" ]];then
      echo "统计访问来源主机TOP 100和分别对应出现的总次数   -a"
      echo "统计访问来源主机TOP 100 IP和分别对应出现的总次数 -b"
      echo "统计最频繁被访问的URL TOP 100 -c"
      echo "统计不同响应状态码的出现次数和对应百分比 -d"
      echo "分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数 -e"
      echo "给定URL输出TOP 100访问来源主机 -f URL"
    fi
