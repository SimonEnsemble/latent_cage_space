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
@load "rotational_inertia_aligned_cages.jld2"

# align cage_y to cage_x
for (i, cage_y) in enumerate(cages)
    # no sense in thinking about moving the rotational-inertia-aligned cages.
    if cage_y in rotational_inertia_aligned_cages
        @printf("aborting cage_y = %d b/c principal axes of inertia has authority here\n", cage_y)
        continue
    end
    for (j, cage_x) in enumerate(cages)
        if i == j
            continue
        end
        write_submit_script(cage_y, cage_x)
       	run(`qsub submit_script.sh`)
       	sleep(1)
    end
end
