
module Measures

abstract Measure

immutable Length{unit} <: Measure
    value::Float64
end

abstract MeasureOp{n} <: Measure
abstract UnaryOp{A} <: MeasureOp{1}
abstract ScalarOp{A} <: MeasureOp{2}
abstract BinaryOp{A, B} <: MeasureOp{2}

immutable Neg{A <: Measure} <: UnaryOp{A}
    a::A
end

immutable Add{A <: Measure, B <: Measure} <: BinaryOp{A, B}
    a::A
    b::B
end

immutable Min{A <: Measure, B <: Measure} <: BinaryOp{A, B}
    a::A
    b::B
end

immutable Max{A <: Measure, B <: Measure} <: BinaryOp{A, B}
    a::A
    b::B
end

immutable Div{A <: Measure} <: ScalarOp{A}
    a::A
    b::Number
end

immutable Mul{A <: Measure} <: ScalarOp{A}
    a::A
    b::Number
end

# Easy simplifications
# TODO: Add more simplifications
Add{P <: Length}(x::P, y::P) = P(x.value + y.value)
Neg{T <: Length}(x::T) = T(-x.value)
Neg(x::Neg) = x.a
Div{T <: Length}(a::T, b::Number) = T(a.value / b)
Mul{T <: Length}(a::T, b::Number) = T(a.value * b)
Max{T <: Length}(a::T, b::T) = T(max(a.value, b.value))
Min{T <: Length}(a::T, b::T) = T(min(a.value, b.value))

iszero(x::Length) = x.value == 0.0
iszero(x::Measure) = false

Base.(:+)(a::Measure, b::Measure) = iszero(a) ? b : iszero(b) ? a : Add(a, b)
Base.(:-)(a::Measure) = Neg(a)
Base.(:-)(a::Neg) = a.value
Base.(:-)(a::Measure, b::Measure) = Add(a, -b)
Base.(:-){T <: Length}(a::T, b::T) = T(a.value - b.value)
Base.(:/)(a::Measure, b::Number) = Div(a, b)
Base.(:*)(a::Measure, b::Number) = Mul(a, b)
Base.(:*)(a::Number, b::Measure) = Mul(b, a)
Base.min(a::Measure, b::Measure) = Min(a, b)
Base.max(a::Measure, b::Measure) = Max(a, b)

const mm   = Length{:mm}(1.0)
const cm   = Length{:mm}(10.0)
const inch = Length{:mm}(25.4)
const pt   = inch/72.0

const w    = Length{:w}(1.0)
const h    = Length{:h}(1.0)
#const d    = Length{:d}(1.0)

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

typealias AbsoluteBox{N}   BoundingBox{N, Length{:mm}, Length{:mm}}
typealias Absolute2DBox    AbsoluteBox{2}

width(x::BoundingBox)  = x.a[1]
height(x::BoundingBox) = x.a[2]
#depth(x::Boundin<Plug>(deoplete_start_complete)gBox)  = x.a[3]

# resolve resolves measures in mm relative to a bounding box
resolve(box::AbsoluteBox, x::Length{:mm}) = x.value
resolve(box::AbsoluteBox, x::Length{:w})  = width(box).value * x.value
resolve(box::AbsoluteBox, x::Length{:h})  = height(box).value * x.value
#resolve(box::AbsoluteBox, x::Length{:d}) = depth(box).value * x.value

resolve(box::AbsoluteBox, x::Neg) = -resolve(box, x.a)
resolve(box::AbsoluteBox, x::Add) = resolve(box, x.a) + resolve(box, x.b)
resolve(box::AbsoluteBox, x::Mul) = resolve(box, x.a) * x.b
resolve(box::AbsoluteBox, x::Div) = resolve(box, x.a) / x.b
resolve(box::AbsoluteBox, x::Min) = min(resolve(box, x.a), resolve(box, x.b))
resolve(box::AbsoluteBox, x::Max) = max(resolve(box, x.a), resolve(box, x.b))
resolve(box::AbsoluteBox, p::Point) =
    Point(map(x -> resolve(box, x)*mm, p.x)) + box.x0
resolve(outer::AbsoluteBox, box::BoundingBox) =
    BoundingBox(Point(resolve(outer, box.x0)), map(x -> resolve(outer, x)*mm, box.a))


Base.show{U}(out::IO, x::Length{U}) = print(out, x.value, U)
Base.show(out::IO, x::Neg) = print(out, "-", x.a)
Base.show(out::IO, x::Add) = print(out, x.a, " + ", x.b)
Base.show(out::IO, x::Min) = print(out, "min(", x.a, ", ", x.b, ")")
Base.show(out::IO, x::Min) = print(out, "max(", x.a, ", ", x.b, ")")
Base.show(out::IO, x::Div) = print(out,  x.a, " / ", x.b)
Base.show(out::IO, x::Mul) = print(out,  x.a, " * ", x.b)


end # module Measures
