#!/bin/bash

#1
i=0
l20=0
b2030=0
h30=0
young=20
old=30
all=0
youngname=""
oldname=""
file=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
for line in $file ;
do
	all=$[$all+1]
	if [[ $line != 'Age' ]];then
                i=$[$i+1]
		if [ $line -lt 20];then
		       l20=$[$l20+1]
		       if [ $line -lt $young ];then
			       young=$line
			       youngname=$(awk -F '\t' 'NR=='$[$all+1]' {print $9}' worldcupplayerinfo.tsv)
		       fi
	  fi
	if [ $line -ge 20 ];then
		if [ $line -le 30 ];then
	         b2030=$[$b2030+1]
    fi
	fi
  if [ $line -gt 30 ];then
	    h30=$[$h30+1]
		  if [ $line -gt $old ];then
			       old=$line
			       oldname=$(awk -F '\t' 'NR=='$[$all+1]' {print$9}' worldcupplayerinfo.tsv)
		  fi
  fi
fi
done

echo "低于二十岁有$l20 "
awk 'BEGIN{printf "%0.2f%\n",'$l20'/'$i'}'

echo "二十到三十之间有$b2030 "
awk 'BEGIN{printf "%0.2f%\n",'$b2030'/'$i'}'

echo "大于三十有$h30 "
awk 'BEGIN{printf "%0.2f%\n",'$h30'/'$i'}'

echo "年龄最大$oldname\n"

echo "年龄最小$youngname"


M=0
F=0
G=0
D=0
files=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
for lin in $files;
do
	if [[ $line != 'Position' ]];then
       case $line in
		      "Goalie") G=$[$G+1];;
		      "Defender") D=$[$D+1];;
		      "Midfielder") M=$[$M+1];;
		      "Forward") F=$[$F+1];;
	     esac
	 fi
done

echo "Goalie $G"
awk 'BEGIN{printf "%0.2f%\n",'$G'/'$i'}'

echo "Defender $D"
awk 'BEGIN{printf "%0.2f%\n",'$D'/'$i'}'

echo "Midfielder $M"
awk 'BEGIN{printf "%0.2f%\n",'$M'/'$i')'

echo "Forward $F"
awk 'BEGIN{printf "%0.2f%\n",'$F'/'$i')'


length=0
min=5
max=10
minname=""
maxname=""
names=$(awk -F '\t' '{print $9}' worldcupplayerinfo.tsv)
for len in $names;
do
length=${#len}
if [[ $length -gt $max ]];then
	max=$length
  maxname=$len
fi
if [[ $length -lt $min ]];then
	min=$length
	minname=$len
fi
done

echo "名字最短$minname"
echo "名字最长$maxname"
