# Load modules
using ThinFilmsTools
using Plots
pyplot(reuse=false, grid=true, size=(640,480))
closeall()

### Input data
# half-width of heater line [m]
b = (12.5/2)*1e-6
# length of heater line [m]
l = 1.0e-3
# range of frequencies [Hz]
f = exp10.(LinRange(0, 9, 1500))
# power [W]
p = 0.030^2*22.11
# heater thermal resistance
ρh = [0.0 0.0] # I only need two actually, see F
# interface thermal resistances
thresistances = [1.0e-8 1.5e-9 1.0e-12]

# Wrap them into structures
layers = [ LayerTOM(310.0, 1.0, 0.2e-6, 2.441e6), # heater
           LayerTOM(1.0, 1.0, 1.0e-6, 2320*700.0), # specimen_1
           LayerTOM(0.1, 1.0, 1.0e-6, 2320*700*0.1), # specimen_2
           LayerTOM(160.0, 1.0, 525.0e-6, 2320*700.) ] # substrate
hgeometry = HeaterGeometry(b, l, ρh)
source = Source(p, f)

# call the model
sol = ThreeOmegaMethod(layers, hgeometry, source, thresistances)

plot(TOMplot(), sol)
gui()

