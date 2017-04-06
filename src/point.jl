
# Higher-order measures

@compat const Vec{N} = NTuple{N, Measure}
const Vec2 = Vec{2}
const Vec3 = Vec{3}

isabsolute(p::Vec) = false
isabsolute{N}(p::NTuple{N, AbsoluteLength}) = true

@compat const AbsoluteVec{N} = NTuple{N, Length{:mm, Float64}}
const AbsoluteVec2 = AbsoluteVec{2}
const AbsoluteVec3 = AbsoluteVec{3}

#Base.zero(::Type{Vec}) = Vec()

@compat Base.:+(a::Vec, b::Vec)  = map(+, a, b)
@compat Base.:-(a::Vec, b::Vec)  = map(-, a, b)
@compat Base.:/(a::Vec, b::Number) = map(x -> x/b, a)
@compat Base.:*(a::Vec, b::Number) = map(x -> x*b, a)
@compat Base.:*(a::Number, b::Vec) = b*a


@compat @generated function Base.:+{N}(a::Vec{N}, b::Vec{N})
    Expr(:tuple, [:(a[$i] + b[$i]) for i=1:N]...)
end
