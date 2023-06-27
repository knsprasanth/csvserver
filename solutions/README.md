*git clone https://github.com/infracloudio/csvserver.git
Cloning into 'csvserver'...
remote: Enumerating objects: 30, done.
remote: Counting objects: 100% (30/30), done.
remote: Compressing objects: 100% (18/18), done.
remote: Total 30 (delta 8), reused 30 (delta 8), pack-reused 0
Receiving objects: 100% (30/30), 7.87 KiB | 7.88 MiB/s, done.
Resolving deltas: 100% (8/8), done.

* sudo docker pull infracloudio/csvserver:latest
latest: Pulling from infracloudio/csvserver
ae43b40a9945: Pull complete 
7bb33bb2db38: Pull complete 
c82d72e1bb76: Pull complete 
Digest: sha256:20bc5a93fac217270fe5c88d639d82c6ecb18fc908283e046d9a3917a840ec1f
Status: Downloaded newer image for infracloudio/csvserver:latest
docker.io/infracloudio/csvserver:latest

* sudo docker pull prom/prometheus:v2.22.0
v2.22.0: Pulling from prom/prometheus
76df9210b28c: Pull complete 
559be8e06c14: Pull complete 
97170ed2e56a: Pull complete 
4a6c0b5646ca: Pull complete 
f6776fcc9f18: Pull complete 
7eed139cfec6: Pull complete 
c0c3c15c8e94: Pull complete 
ad6e678f5b25: Pull complete 
9a8236411762: Pull complete 
0cfb39b876cc: Pull complete 
ffe345581c7a: Pull complete 
033c1a7f7349: Pull complete 
Digest: sha256:60190123eb28250f9e013df55b7d58e04e476011911219f5cedac3c73a8b74e6
Status: Downloaded newer image for prom/prometheus:v2.22.0
docker.io/prom/prometheus:v2.22.0

PArt1 .
1*
sudo docker images
REPOSITORY               TAG       IMAGE ID       CREATED       SIZE
infracloudio/csvserver   latest    8cb989ef80b5   2 years ago   237MB
prom/prometheus          v2.22.0   7adf5a25557b   2 years ago   168MB

2* If it's failing then try to find the reason, once you find the reason, move to the next step.
sudo docker logs csvserver
2023/06/27 07:45:08 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory

3* vi gencsv.sh
--> chmod 755 gencsv.sh 
--> ./gencsv.sh 
--> File 'inputFile' has been generated.
--> cat inputFile 
0, 234
1, 98
2, 34

-->  ./gencsv.sh 2 8
File 'inputFile' has been generated with 7 entries.
--> cat inputFile 
2, 841
3, 902
4, 714
5, 908
6, 417
7, 706
8, 278

4* Run the container again in the background with file generated in (3) available inside the container (remember the reason you found in (2)).

docker build -t csvserver1 .
Sending build context to Docker daemon  79.36kB
Step 1/2 : FROM infracloudio/csvserver:latest
 ---> 8cb989ef80b5
Step 2/2 : ADD inputdata /csvserver/
 ---> e076ed937e49
Successfully built e076ed937e49
Successfully tagged csvserver1:latest


--> docker run -itd --name=csvserver e076ed937e49
a4172543135429f17ead724db692204da331e285f0b8068138e78a3abc07b5aa
 --> docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS      NAMES
a41725431354   e076ed937e49   "/csvserver/csvserver"   3 seconds ago        Up 2 seconds        9300/tcp   csvserver

5* Get shell access to the container and find the port on which the application is listening. Once done, stop / delete the running container.
 --> docker exec -it csvserver /bin/bash
 --> netstat -tnlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp6       0      0 :::9300                 :::*                    LISTEN      1/csvserver         



--> docker stop csvserver
csvserver
--> docker rm csvserver
csvserver

* Same as (4), run the container and make sure
--> docker run -itd --name=csvserver -p 9393:9300 --env CSVSERVER_BORDER=Orange e076ed937e49
3070288b9c279f190421a56dddb5bc496e22b75bca28499a58ff96342948c191
-->docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                       NAMES
3070288b9c27   e076ed937e49   "/csvserver/csvserver"   4 seconds ago    Up 3 seconds    0.0.0.0:9393->9300/tcp, :::9393->9300/tcp   csvserver
