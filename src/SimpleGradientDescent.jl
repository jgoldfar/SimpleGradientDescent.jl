VERSION >= v"0.4.0-dev+6521" && __precompile__()
module SimpleGradientDescent

export minimize, minimizeStatus

@static if VERSION >= v"0.7-"
    using LinearAlgebra: norm
end
@static if VERSION < v"0.7.0-DEV.3057"
    using Compat: copyto!
end

"""
    minimizeStatus

represents the status of the minimization routine.

It has public fields `stepError`, `objError`, `stepNumber`, and `report`.

if `report` is anything other than the symbol `:Converged`, the algorithm did not successfully converge.
"""
struct minimizeStatus{T<:Real}
    stepError::T
    objError::T
    stepNumber::Int
    report::Symbol
end

"""
    minimize(f, fprime, x0; stepSize, stepTolerance, objTolerance, maxSteps)

Minimize a real-valued function `f` with given gradient `fprime` with starting position `x0`.

`x0` may be a scalar or vector.

The algorithm will take at most `maxSteps` steps of length `stepSize`, unless the resulting positions the same up to a difference of `stepTolerance`, or the resulting objective function values are the same up to a difference of `objTolerance`.

Note that for each gradient step, the function(al) will be evaluated once, as will the gradient, so storing those values in a global variable somewhere will provide a record of the steps taken during the gradient descent process.

Returns a tuple `(xMin, fMin, s)`, where `xMin` is the final position, `fMin` is the objective function value, and `s` is a `minimizeStatus` object.
"""
function minimize end

## Scalar argument
function minimize(f, fprime, x0::Real, fCurr = f(x0); stepSize = 1, stepTolerance=1e-6, objTolerance=1e-6, maxSteps = 1000)
    xPrev = x0 + 2*stepTolerance
    fPrev = fCurr + 2*objTolerance
    xCurr = x0

    currStepError = abs(xPrev - xCurr)
    currObjError = abs(fPrev - fCurr)

    stepNumber = 0
    algorithmStatus = :NotConverged

    while stepNumber < maxSteps

        xPrev = xCurr
        fPrev = fCurr

        xCurr = xPrev - stepSize * fprime(xPrev)
        fCurr = f(xCurr)

        currStepError = abs(xPrev - xCurr)
        currObjError = abs(fPrev - fCurr)

        if currStepError < stepTolerance || currObjError < objTolerance
            algorithmStatus = :Converged
            break
        end
        stepNumber += 1
    end
    xCurr, fCurr, minimizeStatus(currStepError, currObjError, stepNumber, algorithmStatus)
end

## Vector argument
function minimize(f, fprime, x0::AbstractArray{<:Real}, fCurr = f(x0); stepSize = 1, stepTolerance=1e-6, objTolerance=1e-6, maxSteps = 1000)
    xPrev = copy(x0) .+ 2*stepTolerance
    fPrev = fCurr + 2*objTolerance
    xCurr = copy(x0)

    currStepError = norm(xPrev - xCurr)
    currObjError = abs(fPrev - fCurr)

    stepNumber = 0
    algorithmStatus = :NotConverged

    while stepNumber < maxSteps

        copyto!(xPrev, xCurr)
        fPrev = fCurr

        gradCurr = fprime(xPrev)

        for (i, fprimeVal) in enumerate(gradCurr)
            @inbounds xCurr[i] = xPrev[i] - stepSize * fprimeVal
        end

        fCurr = f(xCurr)

        currStepError = norm(xPrev - xCurr)
        currObjError = abs(fPrev - fCurr)

        if currStepError < stepTolerance || currObjError < objTolerance
            algorithmStatus = :Converged
            break
        end
        stepNumber += 1
    end
    xCurr, fCurr, minimizeStatus(currStepError, currObjError, stepNumber, algorithmStatus)
end
end # module
