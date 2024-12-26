import aerosandbox as asb

def NeuralAirfoil_2D (airfoil, Re, Ma, alpha):

    af = asb.Airfoil(airfoil)

    a = af.get_aero_from_neuralfoil(
        alpha=alpha,
        Re=Re,
        mach=Ma,
        #model_size="xxxlarge",
    )

    aeroCoeff = [float(a["CL"][0]),float(a["CD"][0]), float(a["CM"][0]), float(a["analysis_confidence"][0])]
    
    return  aeroCoeff

aeroCoeff = NeuralAirfoil_2D (airfoil, Re, Ma, alpha) # type: ignore

#print(aeroCoeff, alpha) # type: ignore