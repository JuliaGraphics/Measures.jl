

immutable BoundingBox{P1 <: Vec, P2 <: Vec}
    x0::P1
    a::P2
end

BoundingBox{P <: Vec, T1 <: Measure, T2 <: Measure}(x0::P, width::T1, height::T2) =
    BoundingBox{P, Tuple{T1, T2}}(x0, (width, height))

#BoundingBox{X}(x0::Vec{2, X}, width::Measure, height::Measure) =
    #BoundingBox{2, X, Measure}(x0, (width, height))

BoundingBox(x0::Measure, y0::Measure, width::Measure, height::Measure) =
    BoundingBox((x0, y0), width, height)

BoundingBox() = BoundingBox(0mm, 0mm, 1w, 1h)
BoundingBox(width, height) = BoundingBox(0mm, 0mm, width, height)

isabsolute{P1, P2}(b::BoundingBox{P1, P2}) = isabsolute(b.x0) && isabsolute(b.a)

typealias AbsoluteBox{N}   BoundingBox{NTuple{N, Length{:mm, Float64}},
                                       NTuple{N, Length{:mm, Float64}}}
typealias Absolute2DBox    AbsoluteBox{Tuple{AbsoluteLength, AbsoluteLength}}

width(x::BoundingBox)  = x.a[1]
height(x::BoundingBox) = x.a[2]
