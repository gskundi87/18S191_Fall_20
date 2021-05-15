### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ e541462f-c2a7-4688-9446-0500b7839d7e
using Images

# ╔═╡ fa811a84-8d1a-417f-907b-6fff78d69bb8
keeptrack = [typeof(1) typeof(1.0) typeof("one") typeof(1//1) typeof([1 2;3 4])]

# ╔═╡ c3dfd314-6b66-4d50-9582-ead32feb81df
typeof(keeptrack)

# ╔═╡ 3e3c2b3b-43a0-4e25-a41e-192fabd8a54c
one_image = load(download("https://www.engageselling.com/blog/wp-content/uploads/2014/12/RefreshBLogDecember2nd.jpg"))

# ╔═╡ a5d9c5e0-a7f9-11eb-03ab-f1423603a0bb
element = one_image

# ╔═╡ 19e63e2c-5637-4d24-b1f3-dc2f1af179da
fill(element,3,4)

# ╔═╡ 3a9b1bc0-9ffd-4370-9185-8760ac85d232
typeof(element)

# ╔═╡ cf4ee3b5-89a6-49d7-b485-52e28595b7d9
typeof(element)

# ╔═╡ 24bf6641-fc66-4808-b0cc-9c2a83483654
element2 = [1 2;3 4]

# ╔═╡ fe661084-a81d-4b55-8b72-bc643c36941e
fill(element2,3,3)

# ╔═╡ Cell order:
# ╠═e541462f-c2a7-4688-9446-0500b7839d7e
# ╠═a5d9c5e0-a7f9-11eb-03ab-f1423603a0bb
# ╠═19e63e2c-5637-4d24-b1f3-dc2f1af179da
# ╠═3a9b1bc0-9ffd-4370-9185-8760ac85d232
# ╠═cf4ee3b5-89a6-49d7-b485-52e28595b7d9
# ╠═fa811a84-8d1a-417f-907b-6fff78d69bb8
# ╠═c3dfd314-6b66-4d50-9582-ead32feb81df
# ╠═3e3c2b3b-43a0-4e25-a41e-192fabd8a54c
# ╠═24bf6641-fc66-4808-b0cc-9c2a83483654
# ╠═fe661084-a81d-4b55-8b72-bc643c36941e
