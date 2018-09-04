using PorousMaterials
using DataFrames
using JLD
using HDF5
using CSV

# read in crystals
crystals = readdir("data\\crystals\\")

# empty dictionary to store results
df = Dict("He" => DataFrame(:cage => String[], Symbol("KH_mol/(m³-bar)") => Float64[],
                                                Symbol("KH_mmol/(g-bar)") => Float64[],
                                                Symbol("KH_mmol/(kg-Pa)") => Float64[],
                                                Symbol("err_KH_mmol/(g-bar)") => Float64[],
                                                Symbol("Qst_kJ/mol") => Float64[],
                                                Symbol("elapsed time (min)") => Float64[]),
          "Xe" => DataFrame(:cage => String[], Symbol("KH_mol/(m³-bar)") => Float64[],
                                                Symbol("KH_mmol/(g-bar)") => Float64[],
                                                Symbol("KH_mmol/(kg-Pa)") => Float64[],
                                                Symbol("err_KH_mmol/(g-bar)") => Float64[],
                                                Symbol("Qst_kJ/mol") => Float64[],
                                                Symbol("elapsed time (min)") => Float64[]),
          "Kr" => DataFrame(:cage => String[], Symbol("KH_mol/(m³-bar)") => Float64[],
                                                Symbol("KH_mmol/(g-bar)") => Float64[],
                                                Symbol("KH_mmol/(kg-Pa)") => Float64[],
                                                Symbol("err_KH_mmol/(g-bar)") => Float64[],
                                                Symbol("Qst_kJ/mol") => Float64[],
                                                Symbol("elapsed time (min)") => Float64[]))
# define insertions used
insertions_per_volume = 1000.0
# define force field used
ljforcefield = "UFF.csv"
# define temperature used *(if temperatures are specific to each crystal, create a
#                         *dictionary with all crystals, specifying each temperature)
temperature = 298.0

# reads in adsorbent(s)
for gas in ["He", "Xe", "Kr"]
    # reads in each crystal in crystals
    for crystal_name in crystals
        # reads in .jld files from henry_sims results folder saved from Henry.jl
       	result_file = "data\\henry_sims\\" * henry_result_savename(Framework(crystal_name), Molecule(gas), temperature,
       	                                     LJForceField(ljforcefield), insertions_per_volume)
        try
            result = load(result_file)["result"]
            push!(df[gas], [cage_name, result["henry coefficient [mol/(m³-bar)]"],
                                       result["henry coefficient [mmol/(g-bar)]"],
                                       result["henry coefficient [mol/(kg-Pa)]"],
                                       result["err henry coefficient [mmol/(g-bar)]"],
                                       result["Qst (kJ/mol)"],
                                       result["elapsed time (min)"]])
            @printf("Found the following file:\n%s\n", result_file)
        catch
            @printf("Did not find the following file:\n%s\n", result_file)
        end
    # writes CSV file using empty dictionary
    CSV.write(gas * "_cage_KH.csv", df[gas])
    end
end
