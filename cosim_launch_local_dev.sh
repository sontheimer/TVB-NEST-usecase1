killall -9 mpirun
killall -9 python3

export CO_SIM_ROOT_PATH="/home/vagrant/multiscale-cosim-repos"
export CO_SIM_MODULES_ROOT_PATH="${CO_SIM_ROOT_PATH}/TVB-NEST-usecase1"
export CO_SIM_USE_CASE_ROOT_PATH="${CO_SIM_MODULES_ROOT_PATH}"

export PYTHONPATH=/home/vagrant/nest_installed/lib/python3.8/site-packages:/home/vagrant/multiscale-cosim-repos/TVB-NEST-usecase1
export PYTHONPATH=$PYTHONPATH:/home/vagrant/NESTServerClient

python3 main.py --global-settings $CO_SIM_USE_CASE_ROOT_PATH/EBRAINS_WorkflowConfigurations/global_settings/global_settings.xml --action-plan $CO_SIM_USE_CASE_ROOT_PATH/EBRAINS_WorkflowConfigurations/plans/cosim_alpha_brunel_on_local.xml
