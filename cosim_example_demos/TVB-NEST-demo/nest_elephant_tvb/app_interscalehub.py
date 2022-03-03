# ------------------------------------------------------------------------------
#  Copyright 2020 Forschungszentrum Jülich GmbH
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

import sys
import time
from Interscale_hub.InterscaleHub import InterscaleHub
from Interscale_hub.parameter import Parameter
from run_setup import RunSetup

def run_wrapper(direction):
# def run_wrapper(path):
    # print(f'****************input from pipe:{input()}')
    # direction
    # 1 --> nest to Tvb
    # 2 --> tvb to nest
    param = Parameter()

    direction = int(direction) # NOTE: will be changed
    # direction = 1 # NOTE: will be changed
    # receive steering commands init,start,stop
    
    if direction == 1:
        RunSetup()  # create directories for logging and to store port information
    else:
        time.sleep(1)

    # 1) init InterscaleHUB
    # includes param setup, buffer creation
    hub = InterscaleHub(param, direction)
    
    # 2) Start signal
    # receive, pivot, transform, send
    hub.start()
    
    # 3) Stop signal
    # disconnect and close ports
    hub.stop()

    
if __name__ == '__main__':
    # RunSetup()
    # args 1 = direction
    sys.exit(run_wrapper(sys.argv[1]))
