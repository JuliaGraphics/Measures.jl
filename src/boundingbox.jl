

struct BoundingBox{P1 <: Vec, P2 <: Vec}
    x0::P1
    a::P2
end

BoundingBox(x0::P, width::T1, height::T2) where {P <: Vec2, T1 <: Measure, T2 <: Measure} =
    BoundingBox{P, Tuple{T1, T2}}(x0, (width, height))

BoundingBox(x0::P, width::T1, height::T2, depth::T3) where {P <: Vec3, T1 <: Measure, T2 <: Measure, T3 <: Measure} =
    BoundingBox{P, Tuple{T1, T2, T3}}(x0, (width, height, depth))

BoundingBox(x0::Measure, y0::Measure, width::Measure, height::Measure) =
    BoundingBox((x0, y0), width, height)

BoundingBox(x0::Measure, y0::Measure, z0::Measure, width::Measure, height::Measure, depth::Measure) =
    BoundingBox((x0, y0, z0), width, height, depth)

BoundingBox() = BoundingBox(0mm, 0mm, 1w, 1h)
BoundingBox(width, height) = BoundingBox(0mm, 0mm, width, height)
BoundingBox(width, height, depth) = BoundingBox(0mm, 0mm, 0mm, width, height, depth)

isabsolute(b::BoundingBox{P1, P2}) where {P1, P2} = isabsolute(b.x0) && isabsolute(b.a)

const AbsoluteBox{N} = BoundingBox{NTuple{N, Length{:mm, Float64}},
                                   NTuple{N, Length{:mm, Float64}}}
const Absolute2DBox  = BoundingBox{Tuple{AbsoluteLength, AbsoluteLength},
                                   Tuple{AbsoluteLength, AbsoluteLength}}
const Absolute3DBox  = BoundingBox{
                                    Tuple{
                                        AbsoluteLength,
                                        AbsoluteLength,
                                        AbsoluteLength
                                    },
                                    Tuple{
                                        AbsoluteLength,
                                        AbsoluteLength,
                                        AbsoluteLength
                                    }
                                }

width(x::BoundingBox)  = x.a[1]
height(x::BoundingBox) = x.a[2]
depth(x::BoundingBox)  = x.a[3]
