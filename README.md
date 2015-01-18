socker
======

Dockerised Ipython Notebook for statistical genetics and PCR-based marker design

Provides
--------

- IPython notebook, SciPy stack
- VCFtools
- VCFLib
- Samtools/HTSLib
- BedTools

To Run
------

- On OSX or Windows, install [Boot2Docker](https://github.com/boot2docker/boot2docker)
- Start up Boot2docker

```
boot2docker up
```

- Start up socker

```
docker run --rm  -v <local dir to mount>:<mount point in VM> -p 8888:8888 -it cfljam/socker
```

- Point your host browser at http://localhost:8888/

=======
Dockerised Ipython Notebook for statistical genetics and marker design

Based on https://github.com/cfljam/statgen_py_vm

Build
------

docker build -t cfljam/socker .

Run
----

docker run -rm -p 8888:8888 -v /my_local_dir:/vm_mount_point -it cfljam/socker
