
# Higher-order measures

@compat const Vec{N} = NTuple{N, Measure}
@compat const Vec2 = Vec{2}
@compat const Vec3 = Vec{3}

isabsolute(p::Vec) = false
isabsolute{N}(p::NTuple{N, AbsoluteLength}) = true

#Vec{T <: Length}(x::T, y::T) = (x, y)
#Vec(x::Measure, y::Measure) = Vec{2, Measure}((x, y))
#Vec() = Vec(0mm, 0mm)

@compat const AbsoluteVec{N} = NTuple{N, Length{:mm, Float64}}
@compat const AbsoluteVec2 = AbsoluteVec{2}
@compat const AbsoluteVec3 = AbsoluteVec{3}

#Base.zero(::Type{Vec}) = Vec()

@compat Base.:+(a::Vec, b::Vec)  = map(+, a, b)
@compat Base.:-(a::Vec, b::Vec)  = map(-, a, b)
@compat Base.:/(a::Vec, b::Number) = map(x -> x/b, a)
@compat Base.:*(a::Vec, b::Number) = map(x -> x*b, a)
@compat Base.:*(a::Number, b::Vec) = b*a


@compat @generated function Base.:+{N}(a::Vec{N}, b::Vec{N})
    Expr(:tuple, [:(a[$i] + b[$i]) for i=1:N]...)
end
