
import Base.==

struct Length{U, T} <: Measure
    value::T
end
Length(unit::Symbol, x::T) where T = Length{unit, T}(x)

const AbsoluteLength = Length{:mm, Float64}

Base.zero(x::AbsoluteLength) = AbsoluteLength(0.0)
Base.convert(::Type{Float64}, x::AbsoluteLength) = x.value

Base.convert(::Type{Length{U, T1}}, x::Length{U, T2}) where {U, T1 <: Number, T2 <: Number} =
    Length{U, T1}(x.value)

==(x::Length{U}, y::Length{U}) where U = x.value == y.value
Base.isequal(x::Length{U}, y::Length{U}) where U = isequal(x.value, y.value)
Base.hash(x::Length{U}) where U = hash(x.value, hash(U))

# Operations
# ----------

Neg(x::T) where T <: Length = T(-x.value)
Div(a::Length{U}, b::Number) where U = Length(U, a.value / b)
Div(a::Length{U}, b::Length{U}) where U = a.value / b.value
Mul(a::Length{U}, b::Number) where U = Length(U, a.value * b)
Max(a::Length{U}, b::Length{U}) where U = Length(U, max(a.value, b.value))
Min(a::Length{U}, b::Length{U}) where U = Length(U, min(a.value, b.value))

Base.:+(a::Length{U}, b::Length{U}) where U = Length(U, a.value + b.value)
Base.:-(a::Length{U}, b::Length{U}) where U = Length(U, a.value - b.value)

iszero(x::Length) = x.value == 0.0

Base.abs(a::T) where {T <: Length} = T(abs(a.value))
Base.isless(a::Length{U}, b::Length{U}) where U = a.value < b.value
Base.oneunit(a::Type{Length{U,T}}) where {U,T} = Length(U, one(T))

isabsolute(::Type{Length{U,T}}) where {U,T} = !in(U, [:w,:h])


# Constants
# ---------

const mm   = AbsoluteLength(1.0)
const cm   = AbsoluteLength(10.0)
const inch = AbsoluteLength(25.4)
const pt   = inch/72.0

const w    = Length{:w, Float64}(1.0)
const h    = Length{:h, Float64}(1.0)
const d    = Length{:d, Float64}(1.0)
