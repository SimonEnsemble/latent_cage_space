using PorousMaterials

# example use, e.g. to run Henry Coefficient simulation of CH4 in FIQCEN_clean.cif
# at 298.0 K with UFF forcefield with 100 insertions.
#   julia run_henry.jl He FIQCEN_clean.cif 298.0 UFF.csv 100

# read in command line arguments
if length(ARGS) != 5
    error("Run as: julia run_henry.jl molecule crystal temperature LJForceField insertions_per_volume")
end

molecule = Molecule(ARGS[1])
crystal = Framework(ARGS[2])
strip_numbers_from_atom_labels!(crystal)
temperature = parse(Float64, ARGS[3])
ljforcefield = LJForceField(ARGS[4], cutoffradius=14.0, mixing_rules="geometric")
insertions_per_volume = parse(Int, ARGS[5])

# run the simulation
result = henry_coefficient(crystal, molecule, temperature, ljforcefield,
                        insertions_per_volume=insertions_per_volume, verbose=true)

# results dictionary autosaved in data/henry_sims
