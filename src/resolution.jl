
# Length
# ------

resolve(box::AbsoluteBox, x::Length{:mm}) = x.value
resolve(box::AbsoluteBox, x::Length{:w})  = width(box).value * x.value
resolve(box::AbsoluteBox, x::Length{:h})  = height(box).value * x.value
#resolve(box::AbsoluteBox, x::Length{:d}) = depth(box).value * x.value


# Operations
# ----------

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

