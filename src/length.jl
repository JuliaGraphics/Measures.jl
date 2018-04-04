
import Base.==

immutable Length{U, T} <: Measure
    value::T
end
Length{T}(unit::Symbol, x::T) = Length{unit, T}(x)

const AbsoluteLength = Length{:mm, Float64}

Base.convert{u, T1 <: Number, T2 <: Number}(::Type{Length{u, T1}}, x::Length{u, T2}) =
    Length{u, T1}(x.value)

=={u}(x::Length{u}, y::Length{u}) = x.value == y.value
Base.isequal{u}(x::Length{u}, y::Length{u}) = isequal(x.value, y.value)
Base.hash{u}(x::Length{u}) = hash(x.value, hash(u))

# Operations
# ----------

Neg{T <: Length}(x::T) = T(-x.value)
Div{u}(a::Length{u}, b::Number) = Length(u, a.value / b)
Div{u}(a::Length{u}, b::Length{u}) = a.value / b.value
Mul{u}(a::Length{u}, b::Number) = Length(u, a.value * b)
Max{u}(a::Length{u}, b::Length{u}) = Length(u, max(a.value, b.value))
Min{u}(a::Length{u}, b::Length{u}) = Length(u, min(a.value, b.value))

Base.:+{u}(a::Length{u}, b::Length{u}) = Length(u, a.value + b.value)
Base.:-{u}(a::Length{u}, b::Length{u}) = Length(u, a.value - b.value)

iszero(x::Length) = x.value == 0.0

Base.abs{T <: Length}(a::T) = T(abs(a.value))
Base.isless{u}(a::Length{u}, b::Length{u}) = a.value < b.value


# Constants
# ---------

const mm   = AbsoluteLength(1.0)
const cm   = AbsoluteLength(10.0)
const inch = AbsoluteLength(25.4)
const pt   = inch/72.0

const w    = Length{:w, Float64}(1.0)
const h    = Length{:h, Float64}(1.0)
const d    = Length{:d, Float64}(1.0)
