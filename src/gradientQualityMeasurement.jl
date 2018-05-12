@static if VERSION >= v"0.7-"
    using LinearAlgebra: dot
end

export gradientQuality, logGradientQuality

function gradientQuality(f, fprime, x0::Real, f0 = f(x0), epsilon::Real=1, dx::Real = 1)
    (f(x0 + epsilon) - f0)/(dx * epsilon * fprime(x0))
end

logGradientQuality(f, fprime, x0::Real, f0 = f(x0), epsilon::Real=1, dx::Real = 1) = log10(abs(gradientQuality(f, fprime, x0, f0, epsilon, dx) - 1))

function gradientQuality(f, fprime, x0::AbstractVector, f0 = f(x0), epsilon::Real = 1, dx::AbstractVector = ones(length(x0)))
    (f(x0 + epsilon * dx) - f0)/(epsilon * dot(fprime(x0), dx))
end

logGradientQuality(f, fprime, x0::AbstractVector, f0 = f(x0), epsilon::Real=1, dx::AbstractVector = ones(length(x0))) = log10(abs(gradientQuality(f, fprime, x0, f0, epsilon, dx) - 1))
