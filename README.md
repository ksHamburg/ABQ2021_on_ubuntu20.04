# ABQ2021_on_ubuntu20.04
How to properly install abaqus 2021 on Ubuntu 20.04 LTS

Installing abaqus on an ubuntu OS always has been and always will be a hassle since abaqus does not support ubuntu natively. 

```
sudo apt-get install docker
```

```
mkdir /tmp/docker
cd /tmp/docker
```

now copy the provied docker file in the Folder ```/tmp/docker``` 

build the docker image
```
docker build -t centos_abq .
```

```
xhost +
```

```
sudo docker run -i -t -v /home:/home --privileged=true --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" centos_abq
```

```-v /home:/home``` mounts the host ```/home``` into the ```/home``` of the docker container.

inside the docker container we need to install abaqus and the intel fortran compiler. I like to have a clean installation which is the reason why we will install both software packages into  ```/opt/SIMULIA``` and ```/opt/intel```.

```
/.../AM_SIM_Abaqus_Extend.AllOS/1/StartGUI.sh
```


```
/.../parallel_studio_xe_2020_update4_cluster_edition/install_GUI.sh
```
do not worry about the violated prerequisites that the detection of cpu support is not met and the the kernel source directory is not found. In my expierence this is not influencing the ifort capabilities which we need to code abaqus user subroutines.


now we need to set up a start up script inside the docker container such that the ```ifort``` is available on runing the image.
```
echo "source /opt/intel/bin/compilervars.sh intel64" >> /etc/bashrc
```

now we are finished with installing everything an 
```
exit
```
the docker container. 
Next all the changes we just made need to be committed to the docker image. In order to do that we have to find out the docker container id vi 
```
sudo docker ps -a
```
It is typically the first entry of the first image showing up. After that we commit the changes via 
```
sudo docker commit containder_id centos_abq
```
and we are done installing.

To start abaqus we type the following commands into the ubuntu console:
```
xhost +;
sudo docker run -i -t -v /home:/home --privileged=true --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" centos_abq
```
which will open the docker container in the interactive mode. In the console of the opened docker container we then type
```
/opt/SIMULIA/Commands/abaqus cae -mesa
```
to finally start and enjoy abaqus 2021.







