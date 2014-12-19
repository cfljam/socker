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
