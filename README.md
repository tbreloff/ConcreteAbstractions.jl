# ConcreteAbstractions

[![Build Status](https://travis-ci.org/tbreloff/ConcreteAbstractions.jl.svg?branch=master)](https://travis-ci.org/tbreloff/ConcreteAbstractions.jl)

Simulate OOP inheritance while using a (superior) Julia abstract type.  Fields and parameters of the "base type" are automatically inserted into the type definition of a "child type".  The "base type" is really an abstract type, but we store the internals of the type definition for later injection into the child definition.

The abstract definition:

```julia
@base type AbstractFoo{T}
    a
    b::Int
    c::T
    d::Vector{T}
end
```

is really more like:

```julia
abstract AbstractFoo
ConcreteAbstractions._base_types[:AbstractFoo] = ([:T], :(begin; a; b::Int; c::T; d::Vector{T}; end))
```

and the child definition:

```julia
@extend type Foo <: AbstractFoo
    e::T
end
```

is really more like:

```julia
type Foo{T} <: AbstractFoo
    a
    b::Int
    c::T
    d::Vector{T}
    e::T
end
```
