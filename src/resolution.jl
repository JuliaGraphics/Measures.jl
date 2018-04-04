
# Length
# ------

resolve(box::AbsoluteBox, x::Length{:mm}) = x
resolve(box::AbsoluteBox, x::Length{:w})  = width(box).value * x.value * mm
resolve(box::AbsoluteBox, x::Length{:h})  = height(box).value * x.value * mm
resolve(box::AbsoluteBox, x::Length{:d})  = depth(box).value * x.value * mm


# Operations
# ----------

resolve(box::AbsoluteBox, x::Neg) = -resolve(box, x.a)
resolve(box::AbsoluteBox, x::Add) = resolve(box, x.a) + resolve(box, x.b)
resolve(box::AbsoluteBox, x::Mul) = resolve(box, x.a) * x.b
resolve(box::AbsoluteBox, x::Div) = resolve(box, x.a) / x.b
resolve(box::AbsoluteBox, x::Min) = min(resolve(box, x.a), resolve(box, x.b))
resolve(box::AbsoluteBox, x::Max) = max(resolve(box, x.a), resolve(box, x.b))
resolve(box::AbsoluteBox, p::Vec) = map(x -> resolve(box, x), p) + box.x0
resolve(outer::AbsoluteBox, box::BoundingBox) =
    BoundingBox(resolve(outer, box.x0), map(x -> resolve(outer, x), box.a))
