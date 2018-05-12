using SimpleGradientDescent

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@static if VERSION >= v"0.7-"
    using LinearAlgebra: norm
end

#TODO: Test that minimize is inferred. v0.6 can't, v0.7 can...

testArgumentTypes = [Float64, BigFloat]
f1(x) = x^2
f1prime(x) = 2*x
@testset "scalar argument" begin
    @testset "Argument type $T" for T in testArgumentTypes
        x0 = T(100)
        xMin, fMin, status = minimize(f1, f1prime, x0, stepSize = 1e-1, stepTolerance=1e-7, objTolerance=1e-7, maxSteps = 1000)
        @test status.report == :Converged
        @test status.stepNumber < 1000
        @test status.stepError < 1e-7 || status.objError < 1e-7
        @test (abs(xMin) < 1e-6) || (abs(fMin) < 1e-6)
    end
end



f2(x) = norm(x)^2
f2prime(x) = 2*x
@testset "vector argument length N=$N" for N in 10:5:20
    @testset "Argument type $T" for T in testArgumentTypes
        x0 = 100*ones(T, N)
        xMin, fMin, status = minimize(f2, f2prime, x0, stepSize = 1e-1, stepTolerance=1e-7, objTolerance=1e-7, maxSteps = 1000)

        @test status.report == :Converged
        @test status.stepNumber < 1000
        @test status.stepError < 1e-7 || status.objError < 1e-7
        @test (norm(xMin) < 1e-6) || abs(fMin) < 1e-6
    end
end
