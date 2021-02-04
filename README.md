# ABQ2021_on_ubuntu20.04

## How to properly install abaqus 2021 on Ubuntu 20.04 LTS using a docker container

Installing abaqus on an ubuntu OS always has been and probably always will be a hassle since abaqus does not support ubuntu natively. However, due to several reasons such as commfort, popularity and mostly lazyness I never considered switching to CentOS and rather fought with the crudities of installing abaqus within ubuntu. Till recently that worked well and there were always ways to get abaqus running smoothly. Some sources of wisdom and inspiration can be found under the following links:

https://polymerfem.com/install-abaqus-2020-on-ubuntu-19-10/
https://github.com/Kevin-Mattheus-Moerman/Abaqus-Installation-Instructions-for-Ubuntu/issues/1
https://github.com/JoKalliauer/abaqus-centos-7-singularity

Unfortunately, for abaqus 2021 analysis do not terminate automatically and user subroutines are not performing smoothly in an ubuntu OS setting which is very anoying. In the end we just want to use abaqus straight away. Coping with installation issues is always frustrating and does not create any value. Therefore I digged the internet to find solutions to the installation problem and am presenting my cook book recepie that shoul run out of the box.

The key incredient is to run abaqus in a docker container that, in some ways, virtualized the supported OS centos. I do not want to get lost in the technical details and start straight away. But first things first, let us recapitulate our starting point and initial configuration:

- Ubuntu 20.04 64bit
- working git command (```sudo apt-get install git```)

Our goal is to install:

- abaqus 2021
- intel fortran compiler for abaqus subroutines (```ifort```-command)

So let's get started. First we need to get docker by downloading docker-desktop from https://www.docker.com/products/docker-desktop.

Now we need to set up the docker container. Therefore we create a temporary working directory and cd into it.
```
mkdir /tmp/docker
cd /tmp/docker
```
Next we need to copy the docker file provided in this githubg by
```

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
