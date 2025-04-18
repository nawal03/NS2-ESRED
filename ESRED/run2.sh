#!/bin/bash

rm -f "throughput.txt"
rm -f "avg-delay.txt"
rm -f "drop-ratio.txt"
rm -f "delivery-ratio.txt"
rm -f "energy-consumption.txt"
rm -f "diff-drop-ratio.txt"

touch tmp.txt
cnt=5
#=============node varying=======================
touch "throughput.txt"
touch "avg-delay.txt"
touch "drop-ratio.txt"
touch "delivery-ratio.txt"
touch "energy-consumption.txt"
touch "diff-drop-ratio.txt"

echo "node count" > out.txt

for ((i=20;i<=100;i+=20))
do
    echo $i >> out.txt
    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl $i 30 300 15 0 > tmp.txt
        awk -f parse.awk trace.tr
    done

    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl $i 30 300 15 1 > tmp.txt
        awk -f parse.awk trace.tr
    done

done
python3 plotter.py
rm out.txt

rm -f "throughput.txt"
rm -f "avg-delay.txt"
rm -f "drop-ratio.txt"
rm -f "delivery-ratio.txt"
rm -f "energy-consumption.txt"
rm -f "diff-drop-ratio.txt"
#===================================================


#==================flow varying=====================
touch "throughput.txt"
touch "avg-delay.txt"
touch "drop-ratio.txt"
touch "delivery-ratio.txt"
touch "energy-consumption.txt"
touch "diff-drop-ratio.txt"

echo "flow count" > out.txt

for ((i=10;i<=50;i+=10))
do
    echo $i >> out.txt
    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl 40 $i 300 15 0 > tmp.txt
        awk -f parse.awk trace.tr
    done

    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl 40 $i 300 15 1 >tmp.txt
        awk -f parse.awk trace.tr
    done

done
python3 plotter.py
rm out.txt

rm -f "throughput.txt"
rm -f "avg-delay.txt"
rm -f "drop-ratio.txt"
rm -f "delivery-ratio.txt"
rm -f "energy-consumption.txt"
rm -f "diff-drop-ratio.txt"
#===================================================


#==================packet rate varying===============
touch "throughput.txt"
touch "avg-delay.txt"
touch "drop-ratio.txt"
touch "delivery-ratio.txt"
touch "energy-consumption.txt"
touch "diff-drop-ratio.txt"

echo "packet rate" > out.txt

for ((i=100;i<=500;i+=100))
do
    echo $i >> out.txt
    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl 40 30 $i 15 0 > tmp.txt
        awk -f parse.awk trace.tr
    done

    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl 40 30 $i 15 1 >tmp.txt
        awk -f parse.awk trace.tr
    done

done
python3 plotter.py
rm out.txt

rm -f "throughput.txt"
rm -f "avg-delay.txt"
rm -f "drop-ratio.txt"
rm -f "delivery-ratio.txt"
rm -f "energy-consumption.txt"
rm -f "diff-drop-ratio.txt"
#===================================================


#==================node speed varying===============
touch "throughput.txt"
touch "avg-delay.txt"
touch "drop-ratio.txt"
touch "delivery-ratio.txt"
touch "energy-consumption.txt"
touch "diff-drop-ratio.txt"

echo "node speed" > out.txt

for ((i=5;i<=25;i+=5))
do
    echo $i >> out.txt
    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl 40 30 300 $i 0 > tmp.txt
        awk -f parse.awk trace.tr
    done

    for((j=0;j<cnt;j++))
    do
	    ns task2.tcl 40 30 300 $i 1 > tmp.txt
        awk -f parse.awk trace.tr
    done

done
python3 plotter.py
rm out.txt

rm -f "throughput.txt"
rm -f "avg-delay.txt"
rm -f "drop-ratio.txt"
rm -f "delivery-ratio.txt"
rm -f "energy-consumption.txt"
rm -f "diff-drop-ratio.txt"
#===================================================

rm tmp.txt