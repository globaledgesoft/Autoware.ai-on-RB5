# Autoware.ai-on-RB5
## Introduction
Autoware.ai is an Autonomous Vehicle development software stack. This project demonstrate that how to deploy Autoware.ai on Qualcomm Robotics RB5 Platform. 
It shows Installation or Bring up of the Popular Autonomous Driving Software Stack Autoware.Ai using Docker. The Autoware.Ai will be built under the ROS Melodic flavor of Robotics Operating System. It has built under the Ubuntu 18.04 Docker image which has installed all the modules of Autoware.AI 
 
## Prerequisites

 - A Linux workstation with Ubuntu 18.04. 
 - Install Android Platform tools (ADB, Fastboot)  
 - Download and install the SDK Manager 
 - Flash the RB5 firmware image on to the board 
 - Setup the Network. 
 - Steps to Install Docker on RB5 

### Installing prerequisites
```sh
$ apt-get update  
$ apt-get install ca-certificates curl gnupg lsb-release 
```
 

### Adding GPG Key
```sh
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
```
 

### Adding repo URL in apt Sources
```sh
$ echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null 
```

### Installing Docker
```sh
$ apt-get update  
$ apt-get install docker-ce docker-ce-cli containerd.io 
```
 

## Steps to Deploy Docker container on RB5 

### Clone the  project repository from the GitHub to RB5
```sh
# git clone <source repository>  
# cd Autoware_On_RB5/ 

# docker build –t autoware.ai:v1 . 
```

### Understanding the Autoware.Ai 

Autoware.AI is ROS based software stack for self-driving vehicles, It enables self-driving vehicles to be fully autonomous to perform the different modules from Autonomy, like Perception, Localizing, Planning, Sensor Interface, Point Cloud Mapping, Simulating environment etc. Autoware, is still under development for the purpose of commercial deployment of self-driving vehicles with functional safety capabilities. 

### Understanding the Docker file for Autoware.Ai 

#### System dependencies for Ubuntu 18.04 / Melodic 

```sh
$ apt update 
$ export ROS_DISTRO=melodic 
$ apt install -y wget git python-catkin-pkg python-rosdep ros-$ROS_DISTRO-catkin 
$ apt install -y python3-pip python3-colcon-common-extensions python3-setuptools python3-vcstool 
$ pip3 install -U setuptools 
```
 

#### Build Process 

 - Creating the workspace 
```sh
$ mkdir -p autoware.ai/src 
$ cd autoware.ai 
```

 - Downloading the Workspace Configuration 
```sh
wget -O autoware.ai.repos https://raw.githubusercontent.com/Autoware-AI/autoware.ai/master/autoware.ai.repos 
```

 - Download Autoware.Ai in Workspace 
```sh
vcs import src < autoware.ai.repos
```
 

 - Installing Dependencies with rosdep 
```sh
$ rosdep init 
$ rosdep update 
$ rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO 
```

 - Compiling the Workspace 
```sh
$ source /opt/ros/melodic/setup.sh 
$ colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release 
```
