### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 43e97a90-a8af-11eb-1495-392dac6120ca
v = [1, 2, 3, 4]

# ╔═╡ b70ee6f3-d34a-4871-91a7-de8b5fccdc63
w = [1 2 3 4
	5 6 7 8]

# ╔═╡ b4b9c17b-f349-4a69-a64f-693cfa58082b
size(w)

# ╔═╡ 9e4303c2-41c1-40e4-b060-ecc04be6cda1
w[1, 1]

# ╔═╡ 505a4912-65f7-429a-91ee-0c606be08c08
w[:,1]

# ╔═╡ 9897d799-c68c-47c6-b093-d6e1b5163a1a
w[2,:]

# ╔═╡ 18773469-a7dc-4782-8493-d509b0ded481
w[:,1:4]

# ╔═╡ 2b22f7f7-c958-4351-ba0b-4b8bd26b7478
A1 = rand(1:9,3,3)

# ╔═╡ bf3f23a4-c434-4904-a101-bca4b84bdab7
begin
	A2 = copy(A1)
	A2[1,1] = 'r'
	A2
end

# ╔═╡ f75a14c1-38a3-465a-9b2b-ec8950debf87
D = [i*j for i=1:9, j=1:9]

# ╔═╡ d9e9be6a-8846-405b-8c22-88fb45fc5a1f
md"""
Squaring by Element
"""

# ╔═╡ 367bd1f1-c1a7-4bfe-8d5b-712a02c5f062
D.^2

# ╔═╡ fdfffcb0-baff-48d9-8f50-3bdd89c14713
md"""
Squaring by Matrix
"""

# ╔═╡ 0705fa10-c988-4fdc-bf8c-d1bf8386e1aa
D^2

# ╔═╡ 3b30da90-f28b-4a90-bbc8-67b1d505acaf
[A1 A2]

# ╔═╡ 601010ac-0982-47ff-9453-8555f81992f8
[A1 A2;A2 A1]

# ╔═╡ Cell order:
# ╠═43e97a90-a8af-11eb-1495-392dac6120ca
# ╠═b70ee6f3-d34a-4871-91a7-de8b5fccdc63
# ╠═b4b9c17b-f349-4a69-a64f-693cfa58082b
# ╠═9e4303c2-41c1-40e4-b060-ecc04be6cda1
# ╠═505a4912-65f7-429a-91ee-0c606be08c08
# ╠═9897d799-c68c-47c6-b093-d6e1b5163a1a
# ╠═18773469-a7dc-4782-8493-d509b0ded481
# ╠═2b22f7f7-c958-4351-ba0b-4b8bd26b7478
# ╠═bf3f23a4-c434-4904-a101-bca4b84bdab7
# ╠═f75a14c1-38a3-465a-9b2b-ec8950debf87
# ╠═d9e9be6a-8846-405b-8c22-88fb45fc5a1f
# ╠═367bd1f1-c1a7-4bfe-8d5b-712a02c5f062
# ╠═fdfffcb0-baff-48d9-8f50-3bdd89c14713
# ╠═0705fa10-c988-4fdc-bf8c-d1bf8386e1aa
# ╠═3b30da90-f28b-4a90-bbc8-67b1d505acaf
# ╠═601010ac-0982-47ff-9453-8555f81992f8
