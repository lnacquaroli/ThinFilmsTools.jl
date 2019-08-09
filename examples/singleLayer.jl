# Load modules
using Plots, LaTeXStrings
pyplot(reuse=false, grid=false)
closeall()
include("ThinFilmsTools.jl")
using Main.ThinFilmsTools
include("RIdb.jl") # collection of refractive indexes data
using Main.RIdb: sno2f, air, silicon

# Define beam
λi = 400 # intial wavelength [nm]
λf = 1000 # final wavelength [nm]
λ = LinRange(λi, λf, λf-λi+1) # wavelength range [nm]
λ0 = 700. # reference wavelength
θ = [0.] # angle of incidence [degrees]
beam = PlaneWave(λ, λ0, θ)

# Define layers
layers = [ LayerTMMO(type=:GT, n=air(beam.λ), d=0.),
           LayerTMMO(type=:GT, n=sno2f(beam.λ), d=150.),
           LayerTMMO(type=:GT, n=silicon(beam.λ), d=0.) ]

# call main script
sol = TMMOptics(beam, layers)

### Optional examples to plot results

# plot the R, T and A spectra
p1 = plot(TMMOplotSpectra1D(), sol.Beam.λ, [sol.Spectra.Rp, sol.Spectra.Tp, 1.0.-(sol.Spectra.Rp.+sol.Spectra.Tp)], label=["Reflectance" "Transmittance" "Absorbance"], line=([:solid :dash :dashdot]), ylims=(0.0,1.0), xlims=(sol.Beam.λ[1], sol.Beam.λ[end]));
plot(p1)
gui()

# plot the refractive index profile
TMMOplotNprofile(sol)
