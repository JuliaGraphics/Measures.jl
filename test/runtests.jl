using Test
using Measures

const imm = Length(:mm, 1)
const rmm = Length(:mm, 1//1)

const xx = Length(:xx, 1.0)

@testset "Bounding boxes" begin
    @testset "Valid bounding box constructors" begin
        @test BoundingBox((0mm, 1mm), 1mm, 2mm) ===
            BoundingBox((0mm, 1mm), 1mm, 2mm)
        @test BoundingBox((2mm, 1mm, 3mm), 1mm, 2mm, 4mm) ===
            BoundingBox((2mm, 1mm, 3mm), 1mm, 2mm, 4mm)
    end

    @testset "Invalid bounding box constructors" begin
        @test_throws MethodError BoundingBox((0mm,), 1mm, 2mm)
        @test_throws MethodError BoundingBox((0mm, 3mm, 8mm), 1mm, 4mm)
        @test_throws MethodError BoundingBox((0mm, 3mm), 1mm, 2mm, 4mm)
        @test_throws MethodError BoundingBox((0mm, 6mm, 3mm, 8mm), 1mm, 2mm, 4mm)
    end
end

@testset "Measure constructors" begin
    @testset "Length constructor" begin
        @test Length(:mm, 1) === Length{:mm, Int}(1)
        @test Length(:mm, 1.1) === Length{:mm, Float64}(1.1)
        @test 1mm |> typeof === Length{:mm, Float64}
        @test convert(Length{:mm, Float64}, 1imm) |> typeof === Length{:mm, Float64}
    end


end

function check_binop(∘) #\circ
    @test (1imm ∘ 2imm).value === 1 ∘ 2
    @test (1mm ∘ 2imm).value === 1.0 ∘ 2
    @test (2mm ∘ 1imm).value === 2.0 ∘ 1
    @test (typeof(2mm ∘ 3xx) <: Length) === false
    @test typeof(2mm ∘ 3xx) <: Measures.BinaryOp
end

function check_unaryop(>:)
    @test >:1imm.value === >:1
    @test >:1.0imm.value !== >:1
    @test >:1.0imm.value === >:1.0
end

@testset "operators" begin
    @testset "type promotion in +" begin
        @test typeof(1imm + 2imm) === Length{:mm, Int}
        @test typeof(1imm + 2mm) === Length{:mm, Float64}
        @test typeof(1mm + 3xx) === Measures.Add{Length{:mm, Float64}, Length{:xx, Float64}}
    end

    @testset "equality" begin
        @test 1imm == 1mm
        @test 1imm !== 1xx
        @test 1imm + 1xx !== 1mm + 1xx # perhaps make this true?
    end

    @testset "hash" begin
        @test hash(1imm) === hash(1mm)
        @test hash(1imm) !== hash(1xx)
        @test isequal(1imm, 1mm)
        @test isequal(1imm, 1xx) === false
    end

    @testset "+" begin
        check_unaryop(+)
        check_binop(+)
    end
    @testset "-" begin
        check_unaryop(-)
        check_binop(-)
    end
    @testset "max" begin
        check_binop(max)
    end
    @testset "min" begin
        check_binop(max)
    end
    @testset "broadcasting" begin
        a = [1mm, 2mm, 3mm]
        @test all((a .+ 1mm) .== [2mm, 3mm, 4mm])
    end

    @testset "Length methods" begin
        @test oneunit(Length{:mm, Int}) == 1mm
        @test !isabsolute(Length{:w, Float32})
    end
end

@testset "range" begin
    @test collect(range(0mm, 1mm, length=3)) == [0mm, 0.5mm, 1mm]
end
