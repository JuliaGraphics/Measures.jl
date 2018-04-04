
abstract type MeasureOp{n} <: Measure end
abstract type UnaryOp{A} <: MeasureOp{1} end
abstract type ScalarOp{A} <: MeasureOp{2} end
abstract type BinaryOp{A, B} <: MeasureOp{2} end

struct Neg{A <: Measure} <: UnaryOp{A}
    a::A
end

struct Add{A <: Measure, B <: Measure} <: BinaryOp{A, B}
    a::A
    b::B
end

struct Min{A <: Measure, B <: Measure} <: BinaryOp{A, B}
    a::A
    b::B
end

struct Max{A <: Measure, B <: Measure} <: BinaryOp{A, B}
    a::A
    b::B
end

struct Div{A <: Measure} <: ScalarOp{A}
    a::A
    b::Number
end

struct Mul{A <: Measure} <: ScalarOp{A}
    a::A
    b::Number
end

# Easy simplifications
# TODO: Add more simplifications
Neg(x::Neg) = x.a
iszero(x::Measure) = false

Base.:+(a::Measure, b::Measure) = Add(a, b)
Base.:-(a::Measure) = Neg(a)
Base.:-(a::Neg) = a.value
Base.:-(a::Measure, b::Measure) = Add(a, -b)
Base.:/(a::Measure, b::Number) = Div(a, b)
Base.:/(a::T, b::T) where T <: Measure = Div(a, b)
Base.:*(a::Measure, b::Number) = Mul(a, b)
Base.:*(a::Number, b::Measure) = Mul(b, a)
Base.min(a::Measure, b::Measure) = Min(a, b)
Base.max(a::Measure, b::Measure) = Max(a, b)
