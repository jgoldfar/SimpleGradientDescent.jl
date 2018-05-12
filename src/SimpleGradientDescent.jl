VERSION >= v"0.4.0-dev+6521" && __precompile__()
module SimpleGradientDescent

include("minimize.jl")

include("gradientQualityMeasurement.jl")

end # module
