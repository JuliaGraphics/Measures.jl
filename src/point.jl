
# Higher-order measures


#typealias Point Tuple{Vararg{Measure}}
#typealias Point2D Tuple{Measure, Measure}
#typealias Point3D Tuple{Measure, Measure, Measure}

typealias Vec{N} NTuple{N, Measure}
typealias Vec2D Vec{2}
typealias Vec3D Vec{3}

isabsolute(p::Vec) = false
isabsolute{N}(p::NTuple{N, AbsoluteLength}) = true

#Vec{T <: Length}(x::T, y::T) = (x, y)
#Vec(x::Measure, y::Measure) = Vec{2, Measure}((x, y))
#Vec() = Vec(0mm, 0mm)

typealias AbsoluteVec{N} NTuple{N, Length{:mm, Float64}}

#Base.zero(::Type{Vec}) = Vec()

Base.(:+)(a::Vec, b::Vec)  = map(+, a, b)
Base.(:-)(a::Vec, b::Vec)  = map(-, a, b)
Base.(:/)(a::Vec, b::Number) = map(x -> x/b, a)
Base.(:*)(a::Vec, b::Number) = map(x -> x*b, a)
Base.(:*)(a::Number, b::Vec) = b*a

