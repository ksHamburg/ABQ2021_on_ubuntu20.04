FROM centos:7
ENV container docker

# GENERALL INSTALLS
RUN yum -y install vim
RUN yum -y install sudo
# RUN yum -y install dnf
# RUN dnf -y group install "Development Tools"
# ABAQUS REQUIRED yum INSTALLS
RUN yum -y install yum install libxkbcommon
RUN yum -y install wget
RUN yum -y install libXScrnSaver
RUN yum -y install yum -y install libEGL
# INSTALL THE libicui18n.50.so50 which is required by abaqus
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/libicu-50.2-4.el7_7.x86_64.rpm
RUN yum -y localinstall libicu-50.2-4.el7_7.x86_64.rpm
RUN yum -y install redhat-lsb-core
RUN yum -y install openmotif
RUN yum -y install libglvnd-glx
RUN yum -y install ksh  # needed for Isight installation
RUN yum -y install glibc-devel # needed to for abq linking of user_subroutines
# INTEL PARALLEL STUDIOS REQURIED yum INSTALLS
RUN yum -y install gtk2 # NEW
RUN yum -y install gtk3 # NEW
RUN yum -y install make
RUN yum -y install kernel-devel
# 32-bit LIBRARIES REQUIRED FOR THE INTEL FORTRAN COMPILER
#RUN yum -y install libgcc*i686 libstdc++*i686 glibc*i686 libgfortran*i686
# we purposly do not install them since they interfere with the x86_64 versions and cause problems in abq paralleization
RUN yum -y install gcc-c++
RUN yum -y install yum install xorg-x11-server-Xorg
# CREATE FOLDERS FOR MANUAL INSTALLATION OF INTEL AND ABQ
RUN mkdir /opt/intel
RUN mkdir /opt/intel/licenses/
RUN mkdir /opt/SIMULIA
