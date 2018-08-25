#!/usr/bin/env bash

# This script is intended as an initialization script used in azuredeploy.json
# See documentation here: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux#template-deployment

# see abbreviated notes in README.md
# comments below:

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
    /usr/bin/git clone https://github.com/fastai/fastai.git
fi

## create data directory
if [ -d "data" ]; then
    echo "data dir already exists"
else
    mkdir data
fi

# download the dogscats data!
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
if [ ! -d ${WD}/fastai ]; then
    echo "fastai was not cloned. Check for errors above!"
else
    ln -s ${WD}/data ${WD}/fastai/courses/dl1/data 
fi

## just use the conda env in the repository
/anaconda/envs/py35/bin/conda clean -ay
## now create the env...
condapath=/home/$adminUser/.conda/envs

if [ ! -d $condapath ]; then
    mkdir -p $condapath
fi

/anaconda/envs/py35/bin/conda env create -f ${WD}/fastai/environment.yml -p $condapath/fastai
## now install it as a kernel:
$condapath/fastai/bin/python -m ipykernel install --name fastai

## update appropriate permissions
chown -R ${adminUser}:${adminUser} ${WD}/data 
chown -R ${adminUser}:${adminUser} ${WD}/fastai
chown -R ${adminUser}:${adminUser} ${condapath}

echo "Done!"
