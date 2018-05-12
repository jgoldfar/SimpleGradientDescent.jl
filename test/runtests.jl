@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@testset "minimize" begin
    include("minimize.jl")
end

@testset "gradientQualityMeasurement" begin
    include("gradientQualityMeasurement.jl")
end