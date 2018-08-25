#!/usr/bin/env bash

# This script is intended as an initialization script used in azuredeploy.json
# See documentation here: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux#template-deployment

# It really just does two things.
# 1. makes sure the fastai repo is cloned in the ~/notebooks directory so that
#    jupyter sees it by default
# 2. makes sure the data is downloaded in the ~/notebooks/data directory, and linked inside fastai/courses/dl1

adminUser=$1

WD=/home/$adminUser/notebooks

echo WD is $WD

if [ ! -d $WD ]; then
    echo $WD does not exist - aborting!!
    exit
else
    cd $WD
    echo "Working in $(pwd)"
fi

if [ -d "fastai" ]; then
    echo "fastai already exists."
else
    /usr/bin/git clone git@github.com:fastai/fastai.git
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

## just use the conda env in the repository
/anaconda/envs/py35/bin/conda clean -a
## now create the env...
/anaconda/envs/py35/bin/conda env create -f ${WD}/fastai/environment.yml
## now install it as a kernel:
## requires sudo access...
sudo /anaconda/envs/fastai/bin/python -m ipykernel install --name fastai
## activate appropriate conda env in case we need to add any pip or conda installs below
# source activate py35

echo "Done!"

# already installed==7.2.1 (should check version requirements)
# pip install ipywidgets
