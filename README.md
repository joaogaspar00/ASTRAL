# ASTRAL

Autorotation System for Targeted Recovery and Aircraft Landing


## Necessary Toolboxes

[Aerospace Toolbox](https://www.mathworks.com/products/aerospace-toolbox.html)

[Robotics System Toolbox](https://www.mathworks.com/products/robotics.html)

[Curve Fitting Toolbox](https://www.mathworks.com/products/curvefitting.html)

## Project Structure

```
ASTRAL 
 ├── airfoils/  
 │   ├── coord/                  # Airfoil coordinate data  
 │   └── data/                   # Airfoil datasets  
 ├── app/  
 │   ├── analysis2D.mlapp        # MATLAB app for 2D analysis  
 │   ├── ASTRAL.mlapp            # Main MATLAB app for ASTRAL
 ├── sim/  
 │   ├── aerodynamic_model/      # Aerodynamic model implementations  
 │   ├── atmospheric_model/      # Atmospheric model data and functions  
 │   ├── bet/                    # Blade Element Theory modules  
 │   ├── class/                  # Class definitions  
 │   ├── dynamics/               # Dynamics equations and motion models  
 │   ├── init/                   # Initialization scripts and parameters  
 │   ├── math/                   # Mathematical utilities and helper functions  
 │   ├── out/                    # Output data and results  
 │   ├── plot_functions/         # Functions for plotting and visualization  
 │   └── solvers/                # Numerical solvers  
 ├── run_simulation.m            # Main simulation execution script  
 ├── setup.m                     # Project setup script  
 ├── log.txt                     # Log file  
 ├── README.md                   # Project documentation  
 ├── .gitattributes              # Git attributes configuration  
 └── .gitignore                  # Git ignore configuration  
```

