
# Higher-order measures

const Vec{N} = NTuple{N, Measure}
const Vec2 = Vec{2}
const Vec3 = Vec{3}

isabsolute(p::Vec) = false
isabsolute(p::NTuple{N, AbsoluteLength}) where N = true

const AbsoluteVec{N} = NTuple{N, Length{:mm, Float64}}
const AbsoluteVec2 = AbsoluteVec{2}
const AbsoluteVec3 = AbsoluteVec{3}

Base.:+(a::Vec, b::Vec)  = map(+, a, b)
Base.:-(a::Vec, b::Vec)  = map(-, a, b)
Base.:/(a::Vec, b::Number) = map(x -> x/b, a)
Base.:*(a::Vec, b::Number) = map(x -> x*b, a)
Base.:*(a::Number, b::Vec) = b*a

@generated function Base.:+(a::Vec{N}, b::Vec{N}) where N
    Expr(:tuple, [:(a[$i] + b[$i]) for i=1:N]...)
end
