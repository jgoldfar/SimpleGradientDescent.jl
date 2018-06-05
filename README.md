# SimpleGradientDescent

[![Build Status (Linux/OSX)](https://travis-ci.org/jgoldfar/SimpleGradientDescent.jl.svg?branch=master)](https://travis-ci.org/jgoldfar/SimpleGradientDescent.jl)
[![Build status (Windows)](https://ci.appveyor.com/api/projects/status/ji5on14wu7e39bgc?svg=true)](https://ci.appveyor.com/project/jgoldfar/mollifiers-jl)
[![Coverage Status](https://coveralls.io/repos/jgoldfar/SimpleGradientDescent.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jgoldfar/SimpleGradientDescent.jl?branch=master)
[![codecov.io](http://codecov.io/github/jgoldfar/SimpleGradientDescent.jl/coverage.svg?branch=master)](http://codecov.io/github/jgoldfar/SimpleGradientDescent.jl?branch=master)

This package is a dead-simple implementation of a gradient descent minimization algorithm; the only advantage to this package over e.g. [Optim](https://github.com/JuliaNLSolvers/Optim.jl), [OptimPack](https://github.com/emmt/OptimPack.jl), or the venerable [NLopt](https://github.com/JuliaOpt/NLopt.jl) package is that this implementation will have no dependencies other than (perhaps) Compat.jl, and will live in a single, well-commented file. That is, the design goal is primarily educational in nature.

The package will also implement Kappa testing to check the accuracy of a given gradient.
