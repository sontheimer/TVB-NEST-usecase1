# TODO: add info and license
# last updates:
#				2022.05.21 - Adding CO_SIM_* env vars
#               28.01.2022
#
# ------------------------------------------------------------------------------
#  Copyright 2020 Forschungszentrum Jülich GmbH and Aix-Marseille Université
# "Licensed to the Apache Software Foundation (ASF) under one or more contributor
#  license agreements; and to You under the Apache License, Version 2.0. "
#
# Forschungszentrum Jülich
#  Institute: Institute for Advanced Simulation (IAS)
#    Section: Jülich Supercomputing Centre (JSC)
#   Division: High Performance Computing in Neuroscience
# Laboratory: Simulation Laboratory Neuroscience
#       Team: Multi-scale Simulation and Design
#
# ------------------------------------------------------------------------------
#
# This research was supported by the EBRAINS research infrastructure, 
# funded from the European Union’s Horizon 2020 Framework Programme for Research and Innovation
# under the Specific Grant Agreement No. 785907 (Human Brain Project SGA2) 
# and No. 945539 (Human Brain Project SGA3).
#

############################
### PACKAGE INSTALLATION ###
############################
# TODO: check versions -- specify versions
apt-get update
apt upgrade
apt-get install build-essential
# -> gcc-9,g++-9: 9.3.0-17ubuntu1~20.04
# -> make: 4.2.1-1.2
apt-get install -y doxygen # 1.8.17-0ubuntu2
apt-get install -y git
apt-get install -y emacs
# NOTE: python 3.8.10-0ubuntu1~20.04.2 is preinstalled
apt-get install -y python3-pip
apt-get install -y python3-all-dev
apt-get install -y python3.8-venv
apt-get install -y cmake # 3.16.3-1ubuntu1
# NOTE: ltdl, readline, boost, gsl (for nest)
apt-get install -y libltdl-dev
apt-get install -y libreadline-dev
apt-get install -y libboost-all-dev
apt-get install -y libgsl-dev

apt-get install -y mpich # 3.3.2-2build1

# TODO: temporary solution:
# both openmpi and mpich were installed and openmpi had higher priority.
# one way to change the default of mpicc and mpirun/mpiexec is to change the alternative:
echo "1" | update-alternatives --config mpi # --> choose mpich
echo "1" | update-alternatives --config mpirun # --> choose mpich

#######################
### PYTHON PACKAGES ###
#######################
pip3 install numba
pip3 install requests
pip3 install wheel
pip3 install cython
#pip3 install numpy # numpy-1.21.x as numba dependecy
pip3 install scipy
pip3 install mpi4py # mpi4py-3.1.3
pip3 install pillow
pip3 install nose
pip3 install elephant # +neo, +quantities dependency
pip3 install matplotlib # for PyNEST
# pip3 install IPython # for PyNEST 
# NOTE: NEST SERVER CLIENT
pip3 install werkzeug
pip3 install docopt
pip3 install flask
pip3 install flask-cors
pip3 install RestrictedPython
pip3 install gunicorn
# install ZeroMQ
pip3 install pyzmq

#################
### GIT SETUP ###
#################
ssh-keyscan github.com >> /home/vagrant/.ssh/known_hosts
# TODO: discussion about multiscale-cosim-team git account and usage
# email/github: multiscale.cosim@gmail.com
# pw: fdL;3+b\
# TODO: discussion about the tvb submodule (in template and usecase)

# create repository directoriy for later...
mkdir /home/vagrant/multiscale-cosim-repos
cd /home/vagrant/multiscale-cosim-repos

#####################################
### TEMPLATE/USECASE REPOSITORIES ###
#####################################
# Template -- integration test and simplest example:
git clone --recurse-submodules https://github.com/sontheimer/ModularScience-Cosim-Template.git

# Usecase Development -- usecase repositoris created from template
git clone --recurse-submodules https://github.com/sontheimer/TVB-NEST-usecase1.git

#########################
### NEST INSTALLATION ###
#########################
# TODO: find out if we should (of have to) use a python_venv specific for NEST
mkdir /home/vagrant/nest-simulator-build/
cd /home/vagrant/nest-simulator-build/

cmake -DCMAKE_INSTALL_PREFIX:PATH=/home/vagrant/nest_installed/ /home/vagrant/multiscale-cosim-repos/TVB-NEST-usecase1/nest-simulator/ \
-Dwith-mpi=ON \
-Dwith-openmp=ON \
-Dwith-readline=ON \
-Dwith-ltdl=ON \
-Dcythonize-pynest=ON \
-DPYTHON_EXECUTABLE=/usr/bin/python3.8 \
-DPYTHON_INCLUDE_DIR=/usr/include/python3.8 \
-DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so

# number of processes can be increased, note: memory on the VM should be increased accordingly to avoid crashes
# Environment variable: $(nproc)
make -j 8
make install
# make installcheck 
# default: Error: PyNEST testing requested, but 'pytest' cannot be run.
# default: Testing also requires the 'pytest-xdist' and 'pytest-timeout' extensions.
# set environment variables
#echo 'source /home/vagrant/nest_installed/bin/nest_vars.sh' >> ~/.bashrc 
echo -e "\e[1;34mINFO -- NEST INSTALLATION COMPLETE!"

########################
### TVB INSTALLATION ###
########################
# required python packages already installed
pip3 install tvb-data==2.0 tvb-gdist==2.1.0 tvb-library==2.2 tvb-contrib==2.2
echo -e "\e[1;34mINFO -- TVB INSTALLATION COMPLETE!"

###########################
### COSIM REPOSITORIES  ###
###########################
cd /home/vagrant/multiscale-cosim-repos
# MS-Cosim Development:
# forks of the 'main' EBRAINS-cosim* repositories for development, regular updates and releases expected. 
git clone https://github.com/sontheimer/EBRAINS_Launcher.git
git clone https://github.com/sontheimer/EBRAINS_ConfigManager.git
git clone https://github.com/sontheimer/EBRAINS_InterscaleHUB.git
git clone https://github.com/sontheimer/EBRAINS_RichEndpoint.git
git clone https://github.com/sontheimer/EBRAINS_WorkflowConfigurations.git

#set rights to execute git commands
chmod -R 777 /home/vagrant/multiscale-cosim-repos

#echo 'export CO_SIM_ROOT_PATH=/home/vagrant/multiscale-cosim-repos' >> ~/.bashrc
#echo 'export CO_SIM_MODULES_ROOT_PATH=${CO_SIM_ROOT_PATH}' >> ~/.bashrc
#echo 'export CO_SIM_USE_CASE_ROOT_PATH=${CO_SIM_ROOT_PATH}/TVB-NEST-usecase1' >> ~/.bashrc

###############
### CLEANUP ###
###############
# nest
rm -r /home/vagrant/nest-simulator-build/
# ...

# setup complete message:
echo -e "\e[1;34mINFO -- BASIC SETUP COMPLETE!"
echo -e "\e[1;34mINFO -- Please configure your personal git account to complete the setup of the development environment!"
