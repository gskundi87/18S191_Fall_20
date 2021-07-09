### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 11b7d810-1ee5-4bc4-9d97-b966d9d6c391
begin
	import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
		Pkg.PackageSpec(name="ImageIO", version="0.5"),
		Pkg.PackageSpec(name="ImageShow", version="0.2"),
		Pkg.PackageSpec(name="FileIO", version="1.6"),
		Pkg.PackageSpec(name="PNGFiles", version="0.3.6"),
		Pkg.PackageSpec(name="Colors", version="0.12"),
		Pkg.PackageSpec(name="ColorVectorSpace", version="0.8"),
        Pkg.PackageSpec(name="ColorSchemes", version="3"),
			
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
    ])
	using Colors, ColorVectorSpace, ImageShow, FileIO
	using ImageShow.ImageCore
	using ColorSchemes

	
	using InteractiveUtils, PlutoUI
	using LinearAlgebra, SparseArrays, Statistics
end

# ╔═╡ b7817ae4-9f93-4b0c-8a77-970c07423cc6
Pkg.add(["Images", "ImageMagick", "Suppressor"])

# ╔═╡ 4c9382f2-faf0-49c7-8ff3-b8f8f5a0ca9d
begin	
	using ImageMagick
	using Images
	using Suppressor
end

# ╔═╡ 9f64f03d-1dca-4504-94d5-3450c7999f3a
md"# Hot Vectors"

# ╔═╡ 28a6e910-d9d9-11eb-3480-43b00465bfa3
myfirstonehotvector = Int64[0, 1, 0, 0, 0, 0]

# ╔═╡ 3cfe23f0-df7f-472f-a3a2-779f4cc1a31a
myfirstonecoldvector = 1 .- myfirstonehotvector

# ╔═╡ f2b1bf04-d2a6-46b9-8a23-13037652f6c4
md"##### Just need a 6 and a 2 and if it is a hot or cold one vector. So create a struct to hold this information"

# ╔═╡ d398aa14-3cc4-4834-83cc-b52e846b72d7
struct OneHot <: AbstractVector{Int64}
	n::Int64
	k::Int64
end

# ╔═╡ e53c3c60-246c-46d5-9af4-09b39595493c
Base.size(x::OneHot) = (x.n,)

# ╔═╡ 741567e4-5f79-42cd-9f50-1fff5d79a23f
Base.getindex(x::OneHot, i::Int64) = Int64(x.k == i)

# ╔═╡ ab650d78-6e14-4658-93cd-3a62aa8a7a49
myonehotstructvector = OneHot(6,2)

# ╔═╡ 47e7970f-4983-484c-b958-5c38875251e0
size(myonehotstructvector)

# ╔═╡ 12c0c70b-e8d4-4792-908a-eb75b2d12cac
getindex(myonehotstructvector,4)

# ╔═╡ bbe16657-e64e-438e-a068-15738e96c421
myonehotstructvector[3]

# ╔═╡ 5b20e424-320e-4f8d-b579-178a13632502
myonehotstructvector[2]

# ╔═╡ a5a736e2-eb29-4441-ada5-598fd532698c
@bind nn Slider(1:20, show_value = true)

# ╔═╡ ce16b6d2-1d09-40a7-9c2e-0a10b110b009
@bind kk Slider(1:nn, show_value = true)

# ╔═╡ 565dda7e-6d84-4eaf-a586-696e9d504d80
myslidingonehotvector = OneHot(nn,kk)

# ╔═╡ 81b8e5be-cd1c-4a0d-b07d-357359c36b02
md"# Diagonal Vectors"

# ╔═╡ 58af7237-011e-4599-a97a-59e4964534af
M1 = [5 0 0
	0 6 0
	0 0 -10]

# ╔═╡ 38a8977a-d4b3-404c-bd33-a4ba7135cdcf
md"##### Better way to represent diagonal matrices"

# ╔═╡ d8e3fa48-d753-4fed-891d-b02575abcd3a
Diagonal(M1)

# ╔═╡ 362543de-71bb-4892-a99c-9da4fcea85d3
Diagonal([5, 6, -10, 4])

# ╔═╡ 93fd7b8e-6bb1-4084-aab4-4a2ee51daa06
md"##### How much info is stored this way?"

# ╔═╡ 92b40f8b-4872-4fd7-b4c9-9236c31cc0b7
md"# Sparse Matrices"

# ╔═╡ 8f7d735b-b5bc-4e6b-b437-fc97c0fbf8a6
md"##### A different representation than Diagonal matrices"

# ╔═╡ a49ac32b-4604-44b6-9503-2691a7633ef8
M1

# ╔═╡ 68bb6838-91f7-4de3-a1a1-f1f12da0d561
sparse(M1)

# ╔═╡ 83869808-c869-4489-9698-69c13013ebff
md"##### AIJ representation  
[1,1] = 5

[2,2] = 6

[3,3] = -10"

# ╔═╡ 2bdb0025-fa62-422c-b0af-bbb4ed000163
[0 8 9;5 0 0;12 0 4]

# ╔═╡ 7ad9a644-30de-4454-bc1f-d65a85ab408d
sparse([0 8 9;5 0 0;12 0 4])

# ╔═╡ b987c124-44d0-4821-af38-b9736a133fbb
md"##### Column Sparse Compressed format"

# ╔═╡ 396df387-8a94-4792-9853-cabce4ee8d99
M2 = sparse([1, 2, 10^6], [4, 9, 10^6], [7, 8, 9])

# ╔═╡ 78260c46-96d6-4602-aa86-016520cb08b2
md"# Random Vectors: is there structure?"

# ╔═╡ 4f186152-3713-4d72-adae-2a730e7c3983
vv = rand(1:9, 1_000_000)

# ╔═╡ a5af7f5f-08ac-4080-a4e0-af1d478942c0
md"##### Can store using lossless compression e.g. run-length encodings"

# ╔═╡ 21a2554f-82ec-4768-afe6-3a3a6287dbbe
md"##### But is there other structure? Some might say no because it is a random vector"

# ╔═╡ 7b538113-2781-4692-a487-6ec1447be39a
md"##### Use Statistical methods for random things"

# ╔═╡ 44f43947-f209-4b90-8daa-90745e97f118
mean(vv), std(vv), sqrt(10 * (2/3))

# ╔═╡ 7318dd26-e00d-4425-bfcc-5d83a3ddd620
m = sum(vv) / length(vv)

# ╔═╡ 918b5854-3a05-4b6e-a307-549ee5d31170
σ² = sum((vv .- m).^2) / (length(vv) - 1)

# ╔═╡ 353a3884-3009-4e9f-a20d-ad15ad209374
sqrt(σ²)

# ╔═╡ 56d46565-a971-47a1-af23-33c36f0a8c00
md"# Multiplication Tables"

# ╔═╡ 898eb08f-e956-47cd-9b25-18e47cae54e3
outer(v,w) = [x*y for x in v, y in w]

# ╔═╡ 3e7f2cf2-ac4f-44ac-b879-0315e73d3028
z = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# ╔═╡ 5bb5e0d1-7ce2-4292-b721-459d8c42dc4f
outer(z,z)

# ╔═╡ 7b00c47e-e105-4252-b033-8b316f5bef43
outer(1:10,1:10)

# ╔═╡ 8e92fbee-1f9b-4632-8933-af2d92d803dc
@bind k Slider(1:12, show_value = true)

# ╔═╡ 8ae4ad63-1f88-4ca6-858a-0afcb174c6b5
outer(1:k,1:k)

# ╔═╡ 2baa0119-1980-41f9-9318-56fdbf3f2189
md"##### Here, only one number 'k' is needed for the multiplication table"

# ╔═╡ acbf9221-218d-4986-8001-44ab589fa17a
md"##### What about this matrix?"

# ╔═╡ 7f97a567-cb14-48f9-97f5-f4d102de9b8f
rand_matrix = outer(rand(10),rand(10))

# ╔═╡ b9155146-5e63-4bf9-8f22-4b6db02905c7
function factor(mult_table)
	v = mult_table[:,1]
	w = mult_table[1,:]
	if v[1] ≠ 0 w/=v[1] end
	if outer(v,w) == mult_table
		return v,w
	else
		error("Input is not a multiplication table")
	end
end

# ╔═╡ 5642cc10-18f4-4b8c-89f7-88620b15b11e
factor(outer([1,2,3],[4,6,8]))

# ╔═╡ 9e3468d8-cd3a-4e10-9c63-6b5ff62630f2
factor(rand_matrix)

# ╔═╡ 87528fde-cd86-4a63-abd1-bf4d8eec5f4f
md"##### It is still just two matrices vectors being multiplied, so that is all the info you need to store"

# ╔═╡ f71e3232-b31e-4ccb-81be-b92fcefb14e6
md"##### But what abouting adding two multiplicatoin tables. Can you factor it?"

# ╔═╡ c00b7727-69fa-47c2-a2b4-4ca85c3e6b94
md"##### Yes, using the SVD"

# ╔═╡ a386def1-4f60-4de9-8ce5-075165ebae0a
A = sum(outer(rand(3),rand(3)) for i in 1:2)

# ╔═╡ c85bcc9b-acfc-4239-a24b-3d461156c23a
md"##### Can see it's exactly the same. It should work better for larger matrices with structure"

# ╔═╡ 130e778f-774a-43c3-a418-d06521f9a97a
begin
	U, Σ, V = svd(A)
	outer(U[:,1], V[:,1] * Σ[1]) + outer(U[:,2], V[:,2] * Σ[2])
end

# ╔═╡ 63d7693e-dbcc-4891-b299-1eebc0f85ef8
B = rand(3,3)

# ╔═╡ 938ae1c1-0b69-4cce-be6b-38eda77269c6
md"##### It can approximate too!"

# ╔═╡ 7b1d1deb-263b-43d1-8e66-a433c0152653
begin
	UU, ΣΣ, VV = svd(B)
	outer(UU[:,1], VV[:,1] * ΣΣ[1]) + outer(UU[:,2], VV[:,2] * ΣΣ[2])
end

# ╔═╡ 27f71895-0084-4823-bf61-a57fea428d68
md"##### Continue with official 01-structure.jl notebook..."

# ╔═╡ 748bce71-1e1f-4a0e-b72f-db90e7bb809d
md"# Functions"

# ╔═╡ a8819604-c8b8-486f-988d-a055ef17bd61
show_vector(x::OneHot) = colors[x .+ 1]'

# ╔═╡ 099e7037-b348-4d38-89c7-5d811275b2dd
begin
	imshow(M) = get.(Ref(ColorSchemes.rainbow), M ./ maximum(M))
	imshow(x::AbstractVector) = imshow(x')
end

# ╔═╡ 5add09bc-6157-4916-9a7a-121b7dc15681
imshow(myslidingonehotvector)

# ╔═╡ f3850d41-d330-4ed5-99e2-f2611a23eef6
imshow(rand_matrix)

# ╔═╡ c531025d-3f3b-43f8-9888-c7ee51a5e8ea
function with_terminal(f)
	local spam_out, spam_err
	@color_output false begin
		spam_out = @capture_out begin
			spam_err = @capture_err begin
				f()
			end
		end
	end
	spam_out, spam_err
	
	HTML("""
		<style>
		div.vintage_terminal {
			
		}
		div.vintage_terminal pre {
			color: #ddd;
			background-color: #333;
			border: 5px solid pink;
			font-size: .75rem;
		}
		
		</style>
	<div class="vintage_terminal">
		<pre>$(Markdown.htmlesc(spam_out))</pre>
	</div>
	""")
end

# ╔═╡ 3407d00c-7c94-44dc-a8ef-7653c63ddf24
with_terminal() do
	dump(myonehotstructvector)
end

# ╔═╡ bc2232e4-0dde-4000-be65-cfac816d8518
with_terminal() do
	dump(M1)
end

# ╔═╡ 4f33b0ee-257f-4c13-afc7-68cf45359000
with_terminal() do
	dump(Diagonal(M1))
end

# ╔═╡ ca588127-d537-43ed-9474-3479de076dec
with_terminal() do
	dump(sparse([0 8 9;5 0 0;12 0 4]))
end

# ╔═╡ Cell order:
# ╠═11b7d810-1ee5-4bc4-9d97-b966d9d6c391
# ╠═b7817ae4-9f93-4b0c-8a77-970c07423cc6
# ╠═4c9382f2-faf0-49c7-8ff3-b8f8f5a0ca9d
# ╟─9f64f03d-1dca-4504-94d5-3450c7999f3a
# ╠═28a6e910-d9d9-11eb-3480-43b00465bfa3
# ╠═3cfe23f0-df7f-472f-a3a2-779f4cc1a31a
# ╟─f2b1bf04-d2a6-46b9-8a23-13037652f6c4
# ╠═d398aa14-3cc4-4834-83cc-b52e846b72d7
# ╠═e53c3c60-246c-46d5-9af4-09b39595493c
# ╠═741567e4-5f79-42cd-9f50-1fff5d79a23f
# ╠═ab650d78-6e14-4658-93cd-3a62aa8a7a49
# ╠═47e7970f-4983-484c-b958-5c38875251e0
# ╠═12c0c70b-e8d4-4792-908a-eb75b2d12cac
# ╠═bbe16657-e64e-438e-a068-15738e96c421
# ╠═5b20e424-320e-4f8d-b579-178a13632502
# ╠═3407d00c-7c94-44dc-a8ef-7653c63ddf24
# ╠═a5a736e2-eb29-4441-ada5-598fd532698c
# ╠═ce16b6d2-1d09-40a7-9c2e-0a10b110b009
# ╠═565dda7e-6d84-4eaf-a586-696e9d504d80
# ╠═5add09bc-6157-4916-9a7a-121b7dc15681
# ╟─81b8e5be-cd1c-4a0d-b07d-357359c36b02
# ╠═58af7237-011e-4599-a97a-59e4964534af
# ╟─38a8977a-d4b3-404c-bd33-a4ba7135cdcf
# ╠═d8e3fa48-d753-4fed-891d-b02575abcd3a
# ╠═362543de-71bb-4892-a99c-9da4fcea85d3
# ╟─93fd7b8e-6bb1-4084-aab4-4a2ee51daa06
# ╠═bc2232e4-0dde-4000-be65-cfac816d8518
# ╠═4f33b0ee-257f-4c13-afc7-68cf45359000
# ╟─92b40f8b-4872-4fd7-b4c9-9236c31cc0b7
# ╟─8f7d735b-b5bc-4e6b-b437-fc97c0fbf8a6
# ╠═a49ac32b-4604-44b6-9503-2691a7633ef8
# ╠═68bb6838-91f7-4de3-a1a1-f1f12da0d561
# ╟─83869808-c869-4489-9698-69c13013ebff
# ╠═2bdb0025-fa62-422c-b0af-bbb4ed000163
# ╠═7ad9a644-30de-4454-bc1f-d65a85ab408d
# ╟─b987c124-44d0-4821-af38-b9736a133fbb
# ╠═ca588127-d537-43ed-9474-3479de076dec
# ╠═396df387-8a94-4792-9853-cabce4ee8d99
# ╟─78260c46-96d6-4602-aa86-016520cb08b2
# ╠═4f186152-3713-4d72-adae-2a730e7c3983
# ╟─a5af7f5f-08ac-4080-a4e0-af1d478942c0
# ╟─21a2554f-82ec-4768-afe6-3a3a6287dbbe
# ╟─7b538113-2781-4692-a487-6ec1447be39a
# ╠═44f43947-f209-4b90-8daa-90745e97f118
# ╠═7318dd26-e00d-4425-bfcc-5d83a3ddd620
# ╠═918b5854-3a05-4b6e-a307-549ee5d31170
# ╠═353a3884-3009-4e9f-a20d-ad15ad209374
# ╟─56d46565-a971-47a1-af23-33c36f0a8c00
# ╠═898eb08f-e956-47cd-9b25-18e47cae54e3
# ╠═3e7f2cf2-ac4f-44ac-b879-0315e73d3028
# ╠═5bb5e0d1-7ce2-4292-b721-459d8c42dc4f
# ╠═7b00c47e-e105-4252-b033-8b316f5bef43
# ╠═8e92fbee-1f9b-4632-8933-af2d92d803dc
# ╠═8ae4ad63-1f88-4ca6-858a-0afcb174c6b5
# ╟─2baa0119-1980-41f9-9318-56fdbf3f2189
# ╟─acbf9221-218d-4986-8001-44ab589fa17a
# ╠═7f97a567-cb14-48f9-97f5-f4d102de9b8f
# ╠═f3850d41-d330-4ed5-99e2-f2611a23eef6
# ╠═b9155146-5e63-4bf9-8f22-4b6db02905c7
# ╠═5642cc10-18f4-4b8c-89f7-88620b15b11e
# ╠═9e3468d8-cd3a-4e10-9c63-6b5ff62630f2
# ╟─87528fde-cd86-4a63-abd1-bf4d8eec5f4f
# ╟─f71e3232-b31e-4ccb-81be-b92fcefb14e6
# ╟─c00b7727-69fa-47c2-a2b4-4ca85c3e6b94
# ╠═a386def1-4f60-4de9-8ce5-075165ebae0a
# ╟─c85bcc9b-acfc-4239-a24b-3d461156c23a
# ╠═130e778f-774a-43c3-a418-d06521f9a97a
# ╠═63d7693e-dbcc-4891-b299-1eebc0f85ef8
# ╟─938ae1c1-0b69-4cce-be6b-38eda77269c6
# ╠═7b1d1deb-263b-43d1-8e66-a433c0152653
# ╟─27f71895-0084-4823-bf61-a57fea428d68
# ╟─748bce71-1e1f-4a0e-b72f-db90e7bb809d
# ╟─a8819604-c8b8-486f-988d-a055ef17bd61
# ╟─099e7037-b348-4d38-89c7-5d811275b2dd
# ╟─c531025d-3f3b-43f8-9888-c7ee51a5e8ea
