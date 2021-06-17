### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ fe4ba61d-9a27-4cae-a6cc-75f576286fc2
begin
	import Pkg
	Pkg.add(["Images", "ImageMagick"])
	using Images
end

# ╔═╡ dd24ad8b-5ae4-491d-bedc-782b78df6b35
begin
	Pkg.add("StaticArrays")
	using StaticArrays
end

# ╔═╡ 00235a62-ceed-11eb-3a33-0791db95f4c0
begin
	f = ind -> ind.I
	f.(CartesianIndices((-2:2,-1:1)))
end

# ╔═╡ a60b6f0c-b5f9-495e-bc8b-86e51564b8a3
CartesianIndices((-2:2,-1:1))[1,1].I

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
philip = load("philip.jpg")

# ╔═╡ Cell order:
# ╠═fe4ba61d-9a27-4cae-a6cc-75f576286fc2
# ╠═dd24ad8b-5ae4-491d-bedc-782b78df6b35
# ╠═00235a62-ceed-11eb-3a33-0791db95f4c0
# ╠═a60b6f0c-b5f9-495e-bc8b-86e51564b8a3
# ╠═73e3543d-3e3e-47b1-92a6-3256b7fc0835
# ╠═94831934-9520-47b1-af80-1609931e4074
# ╠═d1bdf6e1-932d-4cb4-8e13-d0d0b9f88a44
# ╠═8006a802-7026-40c0-b493-ce09acc39535
# ╠═c411fe0b-3c9b-41e7-b6b9-8ca1cc3f8f31
# ╠═9b849e00-bac7-4829-8b89-5bdecded47d8
