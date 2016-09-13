using ConcreteAbstractions
using Base.Test

@base type AbstractFoo{T}
    a
    b::Int
    c::T
    d::Vector{T}
end

@extend type Foo <: AbstractFoo
    e::T
end

@testset begin
    @test Foo <: AbstractFoo

    foo = Foo(10,10,10,[10],5)
    @test isa(foo, Foo{Int})
    @test fieldnames(foo) == [:a,:b,:c,:d,:e]
    @test isa(foo.a, Int)
    @test isa(foo.b, Int)
    @test isa(foo.c, Int)
    @test isa(foo.d, Vector{Int})
    @test isa(foo.e, Int)
end
