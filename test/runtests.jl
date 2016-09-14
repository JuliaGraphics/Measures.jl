using Measures
using FactCheck

const imm = Length(:mm, 1)
const rmm = Length(:mm, 1//1)

const xx = Length(:xx, 1.0)

facts("Bounding boxes") do
    context("Invalid bounding box constructors") do
        @fact_throws MethodError BoundingBox((0mm,), 1mm, 2mm)
        @fact_throws MethodError BoundingBox((0mm, 3mm, 8mm), 1mm, 4mm)
        @fact_throws MethodError BoundingBox((0mm, 3mm), 1mm, 2mm, 4mm)
        @fact_throws MethodError BoundingBox((0mm, 6mm, 3mm, 8mm), 1mm, 2mm, 4mm)
    end
end

facts("Measure constructors") do
    context("Length constructor") do
        @fact Length(:mm, 1) --> Length{:mm, Int}(1)
        @fact Length(:mm, 1.1) --> Length{:mm, Float64}(1.1)
        @fact 1mm |> typeof --> Length{:mm, Float64}
        @fact convert(Length{:mm, Float64}, 1imm) |> typeof --> Length{:mm, Float64}
    end


end

function check_binop(∘) #\circ
    @fact (1imm ∘ 2imm).value === 1 ∘ 2 --> true
    @fact (1mm ∘ 2imm).value === 1.0 ∘ 2 --> true
    @fact (2mm ∘ 1imm).value === 2.0 ∘ 1 --> true
    @fact typeof(2mm ∘ 3xx) <: Length --> false
    @fact typeof(2mm ∘ 3xx) <: Measures.BinaryOp --> true
end

function check_unaryop(>:)
    @fact >:1imm.value === >:1 --> true
    @fact >:1.0imm.value === >:1 --> false
    @fact >:1.0imm.value === >:1.0 --> true
end

facts("operators") do
    context("type promotion in +") do
        @fact typeof(1imm + 2imm) --> Length{:mm, Int}
        @fact typeof(1imm + 2mm) --> Length{:mm, Float64}
        @fact typeof(1mm + 3xx) --> Measures.Add{Length{:mm, Float64}, Length{:xx, Float64}}
    end

    context("equality") do
        @fact 1imm --> 1mm
        @fact 1imm --> not(1xx)
        @fact 1imm + 1xx --> not(1mm + 1xx) # perhaps make this true?
    end

    context("hash") do
        @fact hash(1imm) --> hash(1mm)
        @fact hash(1imm) --> not(hash(1xx))
        @fact isequal(1imm, 1mm) --> true
        @fact isequal(1imm, 1xx) --> false
    end

    context("+") do
        check_unaryop(+)
        check_binop(+)
    end
    context("-") do
        check_unaryop(-)
        check_binop(-)
    end
    context("max") do
        check_binop(max)
    end
    context("min") do
        check_binop(max)
    end
end

FactCheck.exitstatus()
