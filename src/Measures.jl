module Measures

export Measure, Length, AbsoluteLength, BoundingBox, AbsoluteBox, Absolute2DBox,
       Absolute3DBox, Vec, Vec2, Vec3, AbsoluteVec, AbsoluteVec2, AbsoluteVec3,
       isabsolute, resolve,
        mm, cm, inch, pt, width, height

abstract type Measure end

include("operations.jl")
include("length.jl")
include("point.jl")
include("boundingbox.jl")
include("resolution.jl")


Base.show(out::IO, x::Length{U}) where U = print(out, x.value, U)
Base.show(out::IO, x::Neg) = print(out, "-", x.a)
Base.show(out::IO, x::Add) = print(out, x.a, " + ", x.b)
Base.show(out::IO, x::Min) = print(out, "min(", x.a, ", ", x.b, ")")
Base.show(out::IO, x::Max) = print(out, "max(", x.a, ", ", x.b, ")")
Base.show(out::IO, x::Div) = print(out,  x.a, " / ", x.b)
Base.show(out::IO, x::Mul) = print(out,  x.a, " * ", x.b)

Broadcast.broadcastable(x::T) where T<:Measure = Ref(x)

end # module Measures
