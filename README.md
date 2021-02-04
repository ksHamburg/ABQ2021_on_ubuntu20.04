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
git clone https://github.com/ksHamburg/ABQ2021_on_ubuntu20.04 /tmp/docker_for_abq/
cd /tmp/docker_for_abq
```
We build the docker image via
```
docker build -t centos_abq .
```
and allow GUI-applications to open and connect to the ubuntu xserver when running the created container via
```
xhost +
```
Now we run the container interactively by dropping the following command in the console
```
sudo docker run -i -t -v /home:/home --privileged=true --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" centos_abq
```
which opens the container and leaves the container console open ready for execution of commands.
The option
```-v /home:/home``` mounts the host ```/home``` directory into the ```/home``` directory of the docker container.
Next we need to install abaqus and the intel fortran compiler. For this operation to work it is obviously necessary that the installation files are located within the hosts ```/home``` directory (for instance in the ```/home/user/Downloads``` directory).
Since I like to have a clean installation, we will install both software packages into  ```/opt/SIMULIA``` and ```/opt/intel```.
Therefore we drop
```
/home/user/Downloads/AM_SIM_Abaqus_Extend.AllOS/1/StartGUI.sh
```
for the abaqus installation. This installation should run smoothly due to the preinstalled required libraries specified in the ```Dockerfile``` of this github repository.
Last but not least the intel fortran compiler installation might be envoked via
```
/home/user/Downloads//parallel_studio_xe_2020_update4_cluster_edition/install_GUI.sh
```
Here we do not worry about the violated prerequisites, which are a non-working detection of the cpu and a kernel source directory which cannot be found. These issues are related to the functionallity of docker-containers which use or forward the hosts kernel in someway that the intel compiler does not understand natively. In my expierence this is not influencing the ```ifort``` capabilities which we need to code abaqus user subroutines. Furthermore we also do not worry about missing 32-bit libraries. These will interfere with abaqus paralleization capabilities if installed. 
Eventually, we need to set up source command, that sources the intel compilervariables when running the docker container. In order to do that we drop
```
echo "source /opt/intel/bin/compilervars.sh intel64" >> /etc/bashrc
```
which adds the above source-command to the ```/etc/bashrc```.
Finally we are finished with installing abaqus and the intel compiler and exit the docker container via  
```
exit
```

Next, all the changes we just made need to be committed to the docker image. In order to do that we have to find out the docker container id via 
```
sudo docker ps -a
```
Typically, it is the first entry of the first image showing up. With this ```container_id``` we commit the changes via 
```
sudo docker commit containder_id centos_abq
```
and are done installing.

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
