
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
Neg(x::Neg) = x.a
iszero(x::Measure) = false

@compat Base.:+(a::Measure, b::Measure) = Add(a, b)
@compat Base.:-(a::Measure) = Neg(a)
@compat Base.:-(a::Neg) = a.value
@compat Base.:-(a::Measure, b::Measure) = Add(a, -b)
@compat Base.:/(a::Measure, b::Number) = Div(a, b)
@compat Base.:/{T <: Measure}(a::T, b::T) = Div(a, b)
@compat Base.:*(a::Measure, b::Number) = Mul(a, b)
@compat Base.:*(a::Number, b::Measure) = Mul(b, a)
Base.min(a::Measure, b::Measure) = Min(a, b)
Base.max(a::Measure, b::Measure) = Max(a, b)

