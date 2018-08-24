# Notes for running fastai courses on DSVM

- nb_conda is broken
    - 'Internal Server Error' when you go to conda 
    - Solution - manually add kernel once env is setup
- Use `dsvm-setup.sh` to setup requirements
  - really just makes sure the repo is cloned, and the appropriate dataset to start is downloaded
  - could create the environment as well...
    - creating hte environment takes about 60 minutes or so (get better timing est.)

- Issue - it doesn't show up as an environment in jupyter...
  - Solution 1: install everything in py35
  - Solution 2: use environment.yml and add nb_conda, so you can select fastai as an appropriate env

- Lesson 1 issue
    