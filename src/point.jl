
# Higher-order measures


#typealias Point Tuple{Vararg{Measure}}
#typealias Point2D Tuple{Measure, Measure}
#typealias Point3D Tuple{Measure, Measure, Measure}

typealias Point{N} NTuple{N, Measure}
typealias Point2D Point{2}
typealias Point3D Point{3}

isabsolute(p::Point) = false
isabsolute{N}(p::NTuple{N, AbsoluteLength}) = true

#Point{T <: Length}(x::T, y::T) = (x, y)
#Point(x::Measure, y::Measure) = Point{2, Measure}((x, y))
#Point() = Point(0mm, 0mm)

typealias AbsolutePoint{N} NTuple{N, Length{:mm, Float64}}

#Base.zero(::Type{Point}) = Point()

Base.(:+)(a::Point, b::Point)  = map(+, a.x, b.x)
Base.(:-)(a::Point, b::Point)  = map(-, a.x, b.x)
Base.(:/)(a::Point, b::Number) = map(x -> x/b, a.x)
Base.(:*)(a::Point, b::Number) = map(x -> x*b, a.x)
Base.(:*)(a::Number, b::Point) = b*a

