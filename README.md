# Eigencages: Learning a latent space of porous cage molecules

Jupyter Notebook to produce data for:

> A. Sturluson, M. T. Huynh, A. H. P. York, C. M. Simon. Eigencages: Learning a latent space of porous cage molecules.

Source of cage structures:
* DOI: 10.1021/acs.jpcc.7b03848 (CDB41 database courtesy of Kim Jelf's group. See [https://github.com/marcinmiklitz/CDB41.git](https://github.com/marcinmiklitz/CDB41.git).)
* SI of DOI: 10.1038/s41467-018-05271-9


# Structure of repository

.
├── ...
├── svd.ipynb                             # A Julia v1.0 notebook used to illustrate the newly learned latent space of the 74 cages
├── MD\_files                             # Contains all Molecular Dynamics (MD) files used for the fluctuating cages
├── all\_cages                            # Contains all cage structures in a .xyz format
│   ├── all\_cages.txt                    # A list containing the names of all 74 cages
│   └── flexible\_cages.tar.gz            # A tarbar containing the 1600 fluctuating snapshots in a .xyz format
├── cc3                                   # Experimental data for Xe and Kr adsorption in CC3
├── centered\_cages                       # Used for Alignment calculations
├── cpd\_results                          # Stores results from Alignment calculations
├── data                                  # Stores data needed for Energy calculations in PorousMaterials
│   ├── forcefields                       # Stores the force field files, which contain the parameters for LJ potentials
│   ├── molecules                         # Stores the molecules used (He, Xe and Kr)
│   └── grids                             # Stores the energy grids saved
├── final\_aligned\_cages                 # Contains the final aligned cages
├── henry\_coefs                          # Contains files needed to calculate henry coefficients for the cages in PorousMaterials
│   └── data                              # See ./data
├── noria                                 # Experimental data for Xe and Kr adsorption in noria (NC2)
├── paper                                 # LaTeX files for the paper
├── principal\_axes\_rotation\_failure    # Images to illustrate the failure of alignment via principal axes of inertia
├── rotational\_inertia\_aligned\_cages   # The cages after being aligned via principal axes of inertia
├── Explore\_accessibility.ipynb          # A Julia v1.0 notebook used to calculate accessibility of the 74 cages
└── cage\_descriptors.ipynb               # A Python 3 notebook used to calculate descriptors for both the original 74 cages and the fluctuating cages using pywindow
