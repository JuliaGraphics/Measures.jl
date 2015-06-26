
immutable Length{U, T} <: Measure
    value::T
end


const mm   = Length{:mm, Float64}(1.0)
const cm   = Length{:mm, Float64}(10.0)
const inch = Length{:mm, Float64}(25.4)
const pt   = inch/72.0

const w    = Length{:w, Float64}(1.0)
const h    = Length{:h, Float64}(1.0)
#const d    = Length{:d}(1.0)


# Operations
# ----------

Add{P <: Length}(x::P, y::P) = P(x.value + y.value)
Neg{T <: Length}(x::T) = T(-x.value)
Div{T <: Length}(a::T, b::Number) = T(a.value / b)
Mul{T <: Length}(a::T, b::Number) = T(a.value * b)
Max{T <: Length}(a::T, b::T) = T(max(a.value, b.value))
Min{T <: Length}(a::T, b::T) = T(min(a.value, b.value))

Base.(:-){T <: Length}(a::T, b::T) = T(a.value - b.value)

iszero(x::Length) = x.value == 0.0


