using PorousMaterials
using CoherentPointDrift
using JLD2
using Printf

if length(ARGS) != 2
    error("Run as: julia cpd_pair.jl cage_1 cage_2 to align cage 1 to cage 2")
end

cage_y = ARGS[1] # rotate this cage's coords
cage_x = ARGS[2] # to align to this.

@printf("Aligning cage %s to %s\n", cage_y, cage_x)

# read in porosity point clouds
_, x_pt_cld = read_xyz("rotational_inertia_aligned_cages/porosity_point_clouds/" * cage_x * ".xyz")
_, y_pt_cld = read_xyz("rotational_inertia_aligned_cages/porosity_point_clouds/" * cage_y * ".xyz")
println("\t# pts in point clouds: ", size(x_pt_cld)[2])
@assert size(x_pt_cld) == size(y_pt_cld)

if ! isdir("cpd_results")
    mkdir("cpd_results")
end

# transformation is applied not to reference cage but the unaligned cage!
R, t, σ², ℓ = CoherentPointDrift.rigid_point_set_registration(x_pt_cld, y_pt_cld, verbose=true,
                        w=0.0, σ²_tol=0.1, q_tol=1.0, max_nb_em_steps=30, print_ending=true)

@save @sprintf("cpd_results/align_%s_to_%s_%d_pts.jld2", cage_y, cage_x, size(x_pt_cld)[2]) R t σ² ℓ cage_y cage_x
