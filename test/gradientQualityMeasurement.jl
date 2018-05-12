using SimpleGradientDescent

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
    using Random: srand
    using LinearAlgebra: norm
end

testArgumentTypes = [Float64, BigFloat]
epsilonValues = [1/(10^n) for n in 2:5]
f1(x) = x^2
f1prime(x) = 2*x
@testset "scalar argument" begin
    @testset "Argument type $T, epsilon=$epsilon, dx=$dx" for T in testArgumentTypes, epsilon in epsilonValues, dx in [-1,1]
        x0 = T(100)
        epsilonLarger = 2*epsilon
        kappa1 = @inferred gradientQuality(f1, f1prime, x0, f1(x0), epsilon)
        kappa2 = @inferred gradientQuality(f1, f1prime, x0, f1(x0), epsilonLarger)
        @test abs(kappa1-1) <= abs(kappa2-1)

        logKappa1 = @inferred logGradientQuality(f1, f1prime, x0, f1(x0), epsilon)
        logKappa2 = @inferred logGradientQuality(f1, f1prime, x0, f1(x0), epsilonLarger)
        # This test is overkill (log is increasing...), but oh well.
        @test logKappa1 <= logKappa2
    end
end

randIndRNG = srand(20)
f2(x) = norm(x)^2
f2prime(x) = 2*x
@testset "vector argument length N=$N" for N in 10:5:20
    @testset "Argument type $T, epsilon=$epsilon" for T in testArgumentTypes, epsilon in epsilonValues
        x0 = 100*ones(T, N)
        dx1 = ones(T, N)
        epsilonLarger = 2*epsilon
        kappa1 = @inferred gradientQuality(f2, f2prime, x0, f2(x0), epsilon, dx1)
        kappa2 = @inferred gradientQuality(f2, f2prime, x0, f2(x0), epsilonLarger, dx1)
        @test abs(kappa1-1) <= abs(kappa2-1)


        logKappa1 = @inferred logGradientQuality(f2, f2prime, x0, f2(x0), epsilon, dx1)
        logKappa2 = @inferred logGradientQuality(f2, f2prime, x0, f2(x0), epsilonLarger, dx1)
        # This test is overkill (log is increasing...), but oh well.
        @test logKappa1 <= logKappa2

        dx2 = zeros(T, N)
        for i in rand(randIndRNG, 1:N, ceil(Int, N/4))
            dx2[i] = one(T)
            kappa1 = @inferred gradientQuality(f2, f2prime, x0, f2(x0), epsilon, dx2)
            kappa2 = @inferred gradientQuality(f2, f2prime, x0, f2(x0), epsilonLarger, dx2)
            @test abs(kappa1-1) <= abs(kappa2-1)
            dx2[i] = zero(T)
        end
    end
end
