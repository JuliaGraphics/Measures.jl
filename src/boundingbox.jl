

immutable BoundingBox{N, X, A}
    x0::Point{N, X}
    a::NTuple{N, A}
end

BoundingBox{X, T <: Length}(x0::Point{2, X}, width::T, height::T) =
    BoundingBox{2, X, T}(x0, (width, height))

BoundingBox{X}(x0::Point{2, X}, width::Measure, height::Measure) =
    BoundingBox{2, X, Measure}(x0, (width, height))

BoundingBox(x0::Measure, y0::Measure, width::Measure, height::Measure) =
    BoundingBox(Point(x0, y0), width, height)

BoundingBox() = BoundingBox(0mm, 0mm, 1w, 1h)
BoundingBox(width, height) = BoundingBox(0mm, 0mm, width, height)

isabsolute{N}(::BoundingBox{N, Length{:mm}, Length{:mm}}) = true
isabsolute(::BoundingBox) = false

typealias AbsoluteBox{N}   BoundingBox{N, Length{:mm, Float64}, Length{:mm, Float64}}
typealias Absolute2DBox    AbsoluteBox{2}

width(x::BoundingBox)  = x.a[1]
height(x::BoundingBox) = x.a[2]



