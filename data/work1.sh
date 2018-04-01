#!/bin/bash
#-j name -q size rname
#-jd name size
#-w content
#-r name =b/-h
#-c name name
#-h 

a=1
b=100

if [[ $1 == "-j" ]];then
	case $# in
		1) echo "error,please input imagename";;
		2) convert $2 -quality 92 $2
		   echo "default 92 success";;
	        3)echo "error,input size";;
		4) if [ $4 -lt $a ];then
			echo "size should >=1"
		elif [ $4 -gt $b ];then
			echo "size shoule <=100"
		else
			convert $2 -quality $4
			echo "success"
		fi;;
         	5) if [ $4 -lt $a ];then
		   echo "error,size should >=1"
	           elif [ $4 -gt $b ];then
		   echo "error,size should <=100"
	           else
		       convert $2 -quality $4 $5
		   echo "success"
	           fi;;
   esac
fi

if [[ $1 == "-jd" ]];then
	case $# in
		1) echo "error,please input imagename";;
		2) rname="50%defa$2"
	          convert -resize 50% $2 $rname
		 echo "default 50% success";;
	       3) rname="$3$2"
		  convert -resize $3 $2 $rname
		  echo "success";;
  esac
  fi


if [[ $1 == "-w" ]];then
	case $# in
		1) echo "error,please input watercontent";;
		2) for file in *.jpg;
                  do
	          nname="water$file"    	
               	convert $file -gravity southeast -fill black -pointsize 20  -draw "text 5,5 "$2"" $nname
                	done
      			echo "success";;
        esac
fi

if [[ $1 == "-r" ]];then
	case $# in
		1) echo "error,please input name";;
		2) echo "error,please input -b/-h";;
		3) if [[ $3 == "-b" ]];then
			for file in *.jpg;
		       	 do
			 str=$file	 
			 len=${#str}
		         le=len-4
		         l=${file:0 :$le}	 
			 rname=$2$l".jpg"
			 mv $file $rname
	        	 done
	           else
		        for file in *.jpg;
		         do 
		         str=$file
			 len=${#str}
		         le=len-4
		         l=${file:0:$le}	 
			 rname=$l$2".jpg"
			 mv $file $rname
		         done
	           fi
		   echo "success"
		   ;;
        esac
fi



if [[ $1 == "-c" ]];then
case $# in
	1) echo "error,please input png/svg ";;
	2) echo "error ,please input jpg";;
	3)convert $2 $3
		echo "success";;
esac
fi

if [[ $1 == "-h" ]];then
echo "-j name [-q size name]"
echo "-jd name [size]"
echo "-r name -b/-h"
echo "-w content"
echo "-c name name"
fi

