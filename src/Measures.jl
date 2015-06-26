
module Measures

export Measure, Length, resolve, mm, cm, inch, pt

abstract Measure

include("operations.jl")
include("length.jl")
include("point.jl")
include("boundingbox.jl")
include("resolution.jl")


Base.show{U}(out::IO, x::Length{U}) = print(out, x.value, U)
Base.show(out::IO, x::Neg) = print(out, "-", x.a)
Base.show(out::IO, x::Add) = print(out, x.a, " + ", x.b)
Base.show(out::IO, x::Min) = print(out, "min(", x.a, ", ", x.b, ")")
Base.show(out::IO, x::Max) = print(out, "max(", x.a, ", ", x.b, ")")
Base.show(out::IO, x::Div) = print(out,  x.a, " / ", x.b)
Base.show(out::IO, x::Mul) = print(out,  x.a, " * ", x.b)


end # module Measures
