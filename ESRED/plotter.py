import matplotlib.pyplot as plt
import numpy as np



def show_plot(x, y , z,  xlab, ylab):
    plt.plot(x, y, color='r',marker = 'o', label='RED')
    plt.plot(x, z, color='g',marker = 'o', label='SRED')
    plt.grid()
    plt.xlabel(xlab)
    plt.ylabel(ylab)
    plt.legend(loc='best')
    plt.savefig(ylab+' vs '+xlab+'.png')
    plt.close()

x_list  =[]
tp0_list =[]
ad0_list =[]
dlv0_list=[]
drp0_list=[]
eng0_list=[]
dif0_list=[]

x_list  =[]
tp1_list =[]
ad1_list =[]
dlv1_list=[]
drp1_list=[]
eng1_list=[]
dif1_list=[]

fout = open("out.txt", "r")
ftp = open("throughput.txt", "r")
fad = open("avg-delay.txt", "r")
fdlv = open("delivery-ratio.txt", "r")
fdrp = open("drop-ratio.txt","r")
feng = open("energy-consumption.txt", "r")
fdif = open("diff-drop-ratio.txt", "r")

str = fout.readline()

for i in range(0,5):
    x_list.append(int(fout.readline()))

cnt=5

for i in range(0,5):
    sum=0
    for j in range(0,cnt):
        sum+=(float(ftp.readline()))
    tp0_list.append(round(sum/cnt,2))

    sum=0
    for j in range(0,cnt):
        sum+=(float(ftp.readline()))
    tp1_list.append(round(sum/cnt,2))

for i in range(0,5):
    sum=0
    for j in range(0,cnt):
        sum+=(float(fad.readline()))
    ad0_list.append(round(sum/cnt,2))

    sum=0
    for j in range(0,cnt):
        sum+=(float(fad.readline()))
    ad1_list.append(round(sum/cnt,2))

for i in range(0,5):
    sum=0
    for j in range(0,cnt):
        sum+=(float(fdlv.readline()))
    dlv0_list.append(round(sum/cnt,2))

    sum=0
    for j in range(0,cnt):
        sum+=(float(fdlv.readline()))
    dlv1_list.append(round(sum/cnt,2))

for i in range(0,5):
    sum=0
    for j in range(0,cnt):
        sum+=(float(fdrp.readline()))
    drp0_list.append(round(sum/cnt,2))

    sum=0
    for j in range(0,cnt):
        sum+=(float(fdrp.readline()))
    drp1_list.append(round(sum/cnt,2))

for i in range(0,5):
    sum=0
    for j in range(0,cnt):
        sum+=(float(feng.readline()))
    eng0_list.append(round(sum/cnt,2))

    sum=0
    for j in range(0,cnt):
        sum+=(float(feng.readline()))
    eng1_list.append(round(sum/cnt,2))

for i in range(0,5):
    sum=0
    for j in range(0,cnt):
        sum+=(float(fdif.readline()))
    dif0_list.append(round(sum/cnt,4))

    sum=0
    for j in range(0,cnt):
        sum+=(float(fdif.readline()))
    dif1_list.append(round(sum/cnt,4))


show_plot(x_list,tp0_list,tp1_list,str,'throughput(kbps)')
show_plot(x_list,ad0_list,ad1_list,str,'average delay(s)')
show_plot(x_list,dlv0_list,dlv1_list,str,'delivery ratio(%)')
show_plot(x_list,drp0_list,drp1_list,str,'drop ratio(%)')
show_plot(x_list,eng0_list,eng1_list,str,'total energy consumption(KJ)')
show_plot(x_list,dif0_list,dif1_list,str,'diff in drop ratio per node(%)')


fout.close()
ftp.close()
fad.close()
fdlv.close()
fdrp.close()
feng.close()
fdif.close()
