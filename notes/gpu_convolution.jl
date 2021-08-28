### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ fe4ba61d-9a27-4cae-a6cc-75f576286fc2
begin
	import Pkg
	Pkg.add(["Images", "ImageMagick","StaticArrays","LinearAlgebra","OffsetArrays"])
	using StaticArrays
	using Images
	using LinearAlgebra
	using OffsetArrays
end

# ╔═╡ da942fc4-ad10-4376-8bf4-0360cab9622b
using CUDA

# ╔═╡ a89a6220-2a5d-47bf-a8ac-84f3e01f079c
using GPUArrays

# ╔═╡ 00235a62-ceed-11eb-3a33-0791db95f4c0
begin
	f = ind -> ind.I
	f.(CartesianIndices((-2:2,-2:2)))
end

# ╔═╡ a60b6f0c-b5f9-495e-bc8b-86e51564b8a3
CartesianIndices((-2:2,-2:2))[1,1].I

# ╔═╡ 94831934-9520-47b1-af80-1609931e4074
typeof(-1:1)

# ╔═╡ d1bdf6e1-932d-4cb4-8e13-d0d0b9f88a44
@inline function neighbors(I::CartesianIndex{N}, L::Int) where N
	w = L ÷ 2
	ntuple(i->(I.I[i]-w):(I.I[i]+w), Val(N))
end
		

# ╔═╡ 73e3543d-3e3e-47b1-92a6-3256b7fc0835
neighbors(CartesianIndex(0,0),3)

# ╔═╡ 8006a802-7026-40c0-b493-ce09acc39535
begin
	G(x,y,σ = 0.5) = 1/sqrt(2*π*σ^2) * exp(-(x^2+y^2)/(2*σ^2))
	G(I::CartesianIndex{2},σ = 0.5) = G(I.I...,σ)
end

# ╔═╡ c411fe0b-3c9b-41e7-b6b9-8ca1cc3f8f31
g = SMatrix{1,1}

# ╔═╡ 9b849e00-bac7-4829-8b89-5bdecded47d8
julia_logo = load("julia_logo.png")


# ╔═╡ df3bb0f7-b715-4b24-bb2d-d14297e15342
img = julia_logo

# ╔═╡ 375f237c-3975-43ec-8b90-efaf65d59c86
function gaussian_filter(σ, l = 4*ceil(Int,σ)+1)
	w = l ÷ 2
	gauss = SMatrix{l,l}(map(i->G(i,σ), CartesianIndices((-w:w,-w:w))))
	gauss ./ sum(gauss)
end

# ╔═╡ 6e6b967f-7646-49ff-8cff-a177615262f1
function convolve2D(I, A, filter)
	neighborhood = neighbors(I, size(filter,1))
	data = @inbounds view(A,neighborhood...)
	sum(data .* filter)
end

# ╔═╡ db7f16ce-5b5d-42cd-ab91-3f01e4123052
function pad(data, border = 1)
	padded_size = map(s->s+2*border, size(data))
	padded_range = map(s->(1-border):(s+border), size(data))
	range = CartesianIndices(map(s->1:s, size(data)))
	
	odata = OffsetArray(zeros(eltype(data), padded_size), padded_range...)
	odata[range] = data
	odata, collect(range)
end

# ╔═╡ 9e549bc9-ba12-4bfd-97f2-6b3a35b56f32
size(julia_logo)

# ╔═╡ ffe7ef4c-944b-4e6e-b567-1c7049f639ac
σ = 4

# ╔═╡ ce86b824-902f-4469-9443-026477d1c5f7
filter = gaussian_filter(σ)

# ╔═╡ 46ec42ca-ea7f-4d8b-a95a-6977393a76bb
padded_img, range = pad(julia_logo, size(filter, 1) ÷ 2)

# ╔═╡ a0483675-47ad-4869-a844-a19e541d2f46
begin
	blurred = similar(julia_logo)
	blurred = convolve2D.(range, (padded_img,), (filter,))
end

# ╔═╡ af775c52-e678-4cc4-8145-8eb1b3352331
size(blurred)

# ╔═╡ f9dc2e08-a41d-4386-9521-8e25aed580f6
gpu_range = cu(range)

# ╔═╡ 5c7baa6a-4cef-4f16-9956-ed99876fc00a
padded_img

# ╔═╡ 9716c114-734a-4066-a157-e7901a4cc619
typeof(padded_img)

# ╔═╡ 9c159e89-4273-4b98-90a1-88762cf7815f
size(padded_img)

# ╔═╡ 8cf054d6-fffb-41d5-8f37-8a55527af4f8
begin
	import CUDA.Adapt
end

# ╔═╡ 739b6a96-7fa9-484b-b3fd-b450d490b5f0
# begin
# 	Adapt.adapt_structure(to, x::OffsetArray) = OffsetArray(Adapt.adapt(to, parent(x)), x.offsets)
# 	Base.Broadcast.BroadcastStyle(::Type{<:OffsetArray{<:Any, <:Any, AA}}) where AA =  	Base.Broadcast.BroadcastStyle(AA)
# 	forcerun = nothing
# end

# ╔═╡ c54e9e04-26fd-47d5-a99f-7b490a0f77c0
gpu_img = cu(padded_img)

# ╔═╡ 559c3b2f-12c7-4cbd-bbb1-e7ed26e011a3
typeof(gpu_img)

# ╔═╡ 80168a00-296c-48dd-a81f-1bc3bcb896e3
gpu_blurred = cu(similar(img, RGBA{Float64}))

# ╔═╡ bfd0bf1e-5670-4c49-b645-9d897a08aad2
gpu_blurred .= convolve2D.(gpu_range, (gpu_img,), (filter,))

# ╔═╡ Cell order:
# ╠═fe4ba61d-9a27-4cae-a6cc-75f576286fc2
# ╠═00235a62-ceed-11eb-3a33-0791db95f4c0
# ╠═a60b6f0c-b5f9-495e-bc8b-86e51564b8a3
# ╠═73e3543d-3e3e-47b1-92a6-3256b7fc0835
# ╠═94831934-9520-47b1-af80-1609931e4074
# ╠═d1bdf6e1-932d-4cb4-8e13-d0d0b9f88a44
# ╠═8006a802-7026-40c0-b493-ce09acc39535
# ╠═c411fe0b-3c9b-41e7-b6b9-8ca1cc3f8f31
# ╠═9b849e00-bac7-4829-8b89-5bdecded47d8
# ╠═df3bb0f7-b715-4b24-bb2d-d14297e15342
# ╠═375f237c-3975-43ec-8b90-efaf65d59c86
# ╠═6e6b967f-7646-49ff-8cff-a177615262f1
# ╠═db7f16ce-5b5d-42cd-ab91-3f01e4123052
# ╠═a0483675-47ad-4869-a844-a19e541d2f46
# ╠═9e549bc9-ba12-4bfd-97f2-6b3a35b56f32
# ╠═af775c52-e678-4cc4-8145-8eb1b3352331
# ╠═da942fc4-ad10-4376-8bf4-0360cab9622b
# ╠═f9dc2e08-a41d-4386-9521-8e25aed580f6
# ╠═46ec42ca-ea7f-4d8b-a95a-6977393a76bb
# ╠═5c7baa6a-4cef-4f16-9956-ed99876fc00a
# ╠═9716c114-734a-4066-a157-e7901a4cc619
# ╠═9c159e89-4273-4b98-90a1-88762cf7815f
# ╠═ffe7ef4c-944b-4e6e-b567-1c7049f639ac
# ╠═ce86b824-902f-4469-9443-026477d1c5f7
# ╠═8cf054d6-fffb-41d5-8f37-8a55527af4f8
# ╠═739b6a96-7fa9-484b-b3fd-b450d490b5f0
# ╠═c54e9e04-26fd-47d5-a99f-7b490a0f77c0
# ╠═559c3b2f-12c7-4cbd-bbb1-e7ed26e011a3
# ╠═80168a00-296c-48dd-a81f-1bc3bcb896e3
# ╠═bfd0bf1e-5670-4c49-b645-9d897a08aad2
# ╠═a89a6220-2a5d-47bf-a8ac-84f3e01f079c
