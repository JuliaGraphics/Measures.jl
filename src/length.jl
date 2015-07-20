
immutable Length{U, T} <: Measure
    value::T
end

typealias AbsoluteLength Length{:mm, Float64}

Base.convert{u, T1 <: Number, T2 <: Number}(::Type{Length{u, T1}}, x::Length{u, T2}) =
    Length{u, T1}(x.value)


# Operations
# ----------

Add{P <: Length}(x::P, y::P) = P(x.value + y.value)
Add{P <: Length, Q<:Length}(x::P, y::Q) = Add{P, Q}(x, y)
Add(x::Measure, y::Measure) = Add{Measure, Measure}(x, y)

Neg{T <: Length}(x::T) = T(-x.value)
Div{T <: Length}(a::T, b::Number) = T(a.value / b)
Div{T <: Length}(a::T, b::T) = a.value / b.value
Mul{T <: Length}(a::T, b::Number) = T(a.value * b)
Max{T <: Length}(a::T, b::T) = T(max(a.value, b.value))
Min{T <: Length}(a::T, b::T) = T(min(a.value, b.value))

Base.(:+){P <: Length}(a::P, b::P) = Add(a, b)
Base.(:-){T <: Length}(a::T, b::T) = T(a.value - b.value)

iszero(x::Length) = x.value == 0.0

Base.abs{T <: Length}(a::T) = T(abs(a.value))
Base.isless{T <: Length}(a::T, b::T) = a.value < b.value


# Constants
# ---------

const mm   = AbsoluteLength(1.0)
const cm   = AbsoluteLength(10.0)
const inch = AbsoluteLength(25.4)
const pt   = inch/72.0

const w    = Length{:w, Float64}(1.0)
const h    = Length{:h, Float64}(1.0)
#const d    = Length{:d}(1.0)

