socker
======

Dockerised Ipython Notebook for statistical genetics and marker design

Build
------

docker build -t cfljam/socker . 

Run
----

docker run -rm -p 8888:8888 -v /my_local_dir:/vm_mount_point -it cfljam/socker
