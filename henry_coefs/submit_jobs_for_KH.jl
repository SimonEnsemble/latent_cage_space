# GOAL: calculate the KH value of every crystal in /data/crystals with He, Kr, and Xe using one core each

using PorousMaterials
using DataFrames
using CSV

# defines number of insertions of a molecule into a single crystal
insertions_per_volume = 1000.0
# defines Lennard Jones forcefield
ljforcefield = "UFF.csv"
# defines temperature
temperature = 298.0
# defines crystals as the folder which stores all crystals
crystals = readdir("data/crystals/")

"""
Write a job submission script to submit for KH simulation of `gas` in `crystals` at `temperature`.
"""
function write_henry_submit_script(molecule::AbstractString, crystal::String, temperature::Float64,
                                    ljforcefield::String, insertions_per_volume::Float64)
    jobscriptdir = "jobz"
    if ! isdir(jobscriptdir)
        mkdir(jobscriptdir)
    end

    # when this script is run in the cluster, it will print this off as a prompt
    @printf("Writing submission script for Henry Coefficient simulation of %s in %s
            at %f K with %s with %d Widom insertions.\n",
            molecule, crystal, temperature, ljforcefield, insertions_per_volume)

    # build KH_submit.sh script to be run in the cluster
    KH_submit = open("KH_submit.sh", "w")
    @printf(KH_submit,
    """
    #!/bin/bash

    # use current working directory for input and output
    # default is to use the users home directory
    #\$ -cwd

    # name this job
    #\$ -N KH_data

    # send stdout and stderror to this file
    #\$ -o jobz/%s.o
    #\$ -e jobz/%s.e

    # select queue - if needed; mime5 is SimonEnsemble priority queue but is restrictive.
    ##\$ -q share,share2,share3,share4, mime5

    # print date and time
    date
    julia run_henry.jl %s %s %f %s %s %d
    """, crystal * "_" * molecule * "_" * mixing_rules, crystal * "_" * molecule * "_" * mixing_rules, molecule, crystal, temperature,
        ljforcefield, mixing_rules, insertions_per_volume)
    close(KH_submit)
end

# reads in adsorbent(s)
for gas in ["He", "Xe", "Kr"]
    # reads in a crystal from crystals folder
	for crystal_name in crystals
       	 # submission file filled in by molecule and crystal of interest
       	 write_henry_submit_script(gas, crystal_name, temperature, ljforcefield, insertions_per_volume)
       	 # runs script to the cluster
       	 run(`qsub KH_submit.sh`)
       	 sleep(1)
	end
end
