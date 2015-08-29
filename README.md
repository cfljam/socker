socker
======

Dockerised Jupyter (ipython) Notebook for statistical genetics and genomics

Built on [cfljam/pyrat_genetics](https://github.com/cfljam/pyRat_genetics)

For info about ipython scipystack see http://odewahn.github.io/docker-jumpstart/ipython-notebook.html

Provides
--------

- VCFtools
- VCFLib
- Samtools/HTSLib
- BedTools
- R genetics tools

To Run
------

- On OSX or Windows, install  [docker toolbox](https://www.docker.com/toolbox)
- Start up Docker-machine

```
docker-machine start <name-of-my-machine>
eval "$(docker-machine env <name-of-my-machine>)"
```

- Pull and run the image

```
docker run -rm -p 8888:8888 -v /my_local_dir:/vm_mount_point -it cfljam/socker
```

## Note

On OSX or Windows using Boot2docker host you will likely  need to open ports in VirtualBox by
doing this manually

e.g. for port 8888

**Settings->Network -> Port Forwarding**

![PortFwdVB](https://dl.dropboxusercontent.com/u/8064851/images/VirtualBoxPortForwardiPynbExample.png)
