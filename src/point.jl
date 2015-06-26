
# Higher-order measures
immutable Point{N, T}
    x::NTuple{N, T}
end
Point{T <: Length}(x::T, y::T) = Point{2, T}((x, y))
Point(x::Measure, y::Measure) = Point{2, Measure}((x, y))
Point() = Point(0mm, 0mm)

Base.zero(::Type{Point}) = Point()
isabsolute{N}(::Point{N, Length{:mm}}) = true
isabsolute(::Point) = false

Base.(:+)(a::Point, b::Point)  = map(+, a.x, b.x)
Base.(:-)(a::Point, b::Point)  = map(-, a.x, b.x)
Base.(:/)(a::Point, b::Number) = map(x -> x/b, a.x)
Base.(:*)(a::Point, b::Number) = map(x -> x*b, a.x)
Base.(:*)(a::Number, b::Point) = b*a
