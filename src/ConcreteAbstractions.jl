module ConcreteAbstractions

export
    @base,
    @extend

const _base_types = Dict{Symbol, Tuple}()

macro base(typeexpr::Expr)
    @assert typeexpr.head == :struct
    mutable, nameblock, args = typeexpr.args

    # extract name and parameters
    name, params =
        if isa(nameblock, Symbol)
            nameblock, []
        elseif nameblock.head == :curly
            nameblock.args[1], nameblock.args[2:end]
        end

    # add this to our list of base types, then return the call to abstract
    _base_types[name] = params, args

    # create abstract type with base type name
    quote
        abstract type $name end
    end
end

macro extend(typeexpr::Expr)
    @assert typeexpr.head == :struct
    mutable, nameblock, args = typeexpr.args

    # create a curly expression for the new type and grab the base name
    @assert isa(nameblock, Expr) && nameblock.head == :(<:)
    curly, basename = nameblock.args
    if isa(curly, Symbol)
        curly = :($curly{})
    end

    # check that we defined this base type
    if !haskey(_base_types, basename)
        error("You must define a base type $basename")
    end

    # extract the base params/args
    params, baseargs = _base_types[basename]

    # add base parameters to def
    curly.args = vcat(curly.args[1], params, curly.args[2:end])
    nameblock.args[1] = curly

    # add base fields to def
    prepend!(args.args, baseargs.args)

    # return the new type expression
    esc(typeexpr)
end

end # module
