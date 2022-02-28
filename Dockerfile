FROM ubuntu:18.04

ENV ROS_DISTRO=melodic

RUN apt-get update
RUN apt-get install -y lsb-core

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/ros-latest.list

# Removing Old GPG Key of ROS package repository
RUN apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

RUN apt-get install -y python-catkin-pkg python-rosdep ros-melodic-catkin
RUN apt-get install -y python3-pip python3-colcon-common-extensions python3-setuptools python3-vcstool
RUN pip3 install -U setuptools

RUN apt-get install -y wget git

RUN mkdir -p autoware.ai/src
WORKDIR ./autoware.ai

RUN wget -O autoware.ai.repos "https://raw.githubusercontent.com/Autoware-AI/autoware.ai/master/autoware.ai.repos"
RUN vcs import src < autoware.ai.repos

RUN rosdep init

RUN rosdep update
RUN rosdep install -y --from-paths src --ignore-src --rosdistro melodic

SHELL ["/bin/bash", "-c"] 

RUN source /opt/ros/melodic/setup.sh && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
