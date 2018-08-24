#!/usr/bin/env bash

# This should set up an Ubuntu DSVM for this course
# Assumes you've deployed an NC-series VM, so CUDA
# is already installed in the py35 conda env
# this is based on the last part of 
# http://files.fast.ai/setup/paperspace

# It really just does two things.
# 1. makes sure the fastai repo is cloned in the ~/notebooks directory so that
#    jupyter sees it by default
# 2. makes sure the data is downloaded in the ~/notebooks/data directory, and linked inside fastai/courses/dl1

## Usage approach number 1:
## You can use this files via direct download:
## wget https://raw.githubusercontent.com/jreynolds01/fastai/dsvm-setup/dsvm-setup.sh
## chmod u+x dsvm-setup.sh
## ./dsvm-setup.sh

## Usage approach number 2:
## Clone and run from github using git
## logged into the DSVM:
## cd ~/notebooks
## ## just using this repo/branch because this script isn't official.
## git clone https://github.com/jreynolds01/fastai.git
## cd fastai
## git checkout dsvm-setup
## ./dsvm-setup.sh

WD=~/notebooks

cd $WD
echo "Working in `pwd`"

if [ -d "fastai" ]; then
    echo "fastai already exists."
else
    git clone git@github.com:fastai/fastai.git
fi

## create data directory
if [ -d "data" ]; then
    echo "data dir already exists"
else
    mkdir data
fi

# download the dogscats data!
# do this...
cd data
if [ -d dogscats ]; then
    echo "dogscats already exists!"
else
    echo "downloading data..."
    wget http://files.fast.ai/data/dogscats.zip
    echo "unzipping data..."
    ## never overwrite files
    unzip -qn dogscats.zip
    ## clean up zipfile
    echo "Removing zip file!"
    /bin/rm ${WD}/data/dogscats.zip
fi

## link data dir in the dl1 course.
cd ${WD}/fastai/courses/dl1/
ln -s ~/data ./

# not sure utility of this - will come back after walking through course...
## just use the conda env in the repository
## need to clean up to make sure there's space...
conda clean -a
## now create the env...
conda env create -f ${WD}/fastai/environment.yml
## now install it as a kernel:
## requires sudo access...
sudo /anaconda/envs/fastai/bin/python -m ipykernel install --name fastai
## activate appropriate conda env in case we need to add any pip or conda installs below
# source activate py35

echo "Done!"

#jupyter notebook --generate-config
#echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
#echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py

# already installed==7.2.1 (should check version requirements)
#pip install ipywidgets
# looks like they are installed.
#jupyter nbextension enable --py widgetsnbextension --sys-prefix
# echo
# echo ---
# echo - YOU NEED TO REBOOT YOUR PAPERSPACE COMPUTER NOW
# echo ---