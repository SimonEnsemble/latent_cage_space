using DelimitedFiles
using Printf

function write_submit_script(cage_y::AbstractString, cage_x::AbstractString)
    jobscriptdir = "jobz"
    if ! isdir(jobscriptdir)
        mkdir(jobscriptdir)
    end

    @printf("Writing submission script for CPD-alignment of %s to %s\n", cage_y, cage_x)

    # build KH_submit.sh script to be run in the cluster
    submit_script = open("submit_script.sh", "w")
    @printf(submit_script,
    """
    #!/bin/bash

    # use current working directory for input and output
    # default is to use the users home directory
    #\$ -cwd

    # name this job
    #\$ -N %s_%s

    #\$ -pe thread 1 # use 1 threads/cores

    # send stdout and stderror to this file
    #\$ -o jobz/%s_%s.o
    #\$ -e jobz/%s_%s.e

    # select queue - if needed; mime5 is SimonEnsemble priority queue but is restrictive.
    ##\$ -q mime5

    # print date and time
    date
    julia cpd_pair.jl %s %s
    """, cage_y, cage_x, cage_y, cage_x, cage_y, cage_x, cage_y, cage_x)
    close(submit_script)
end

cages = readdlm("all_cages/all_cages.txt", String)[:];

for (i, cage_i) in enumerate(cages)
    for (j, cage_j) in enumerate(cages)
        if i == j
            continue
        end
        write_submit_script(cage_i, cage_j)
 #        	run(`qsub submit_script.sh`)
       	sleep(1)
    end
end
