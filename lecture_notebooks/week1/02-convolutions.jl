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

# ╔═╡ 60ec8674-4aa1-4fb4-aaa2-91bf43caa392
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["Images", "Statistics", "FFTW", "Plots", "DSP", "ImageFiltering", 	"PlutoUI"])
end

# ╔═╡ 1ca14906-eca1-11ea-23f6-472ed97d75aa
begin
	using Statistics
	using Images
	using FFTW
	using Plots
	using DSP
	using ImageFiltering
	using PlutoUI
end

# ╔═╡ 42ed52ba-ed34-11ea-26b5-05379824cbc0
md"""
# Convolutions with various kernels
"""

# ╔═╡ 1855256d-39e3-4cfd-8d5a-3f5fa849cd73
@bind s_box Slider(0:1:100, show_value=true)

# ╔═╡ 4c13d558-ee15-11ea-2ed9-c5fb90d93881
kernel = Kernel.gaussian((s_box, s_box))

# ╔═╡ af27fb0f-b8c5-413a-8ab9-50583904229c
kernel[-6,-6]

# ╔═╡ 673f7ac0-ee16-11ea-35d0-cf3da430b843
sum(kernel)

# ╔═╡ 92407bf6-9e4c-4ab8-ab79-d981afb8f8cb
kernel1 = centered([
		-0.5 -1.0 -0.5
		-1.0 7.0 -1.0
		-0.5 -1.0 -0.5
		])

# ╔═╡ d3985849-4b2f-4e34-879c-00d0edfe389d
kernel1[-1,-1]

# ╔═╡ b1ad3ed5-4c44-45ca-a470-3123ec7f8b5e
sum(kernel1)

# ╔═╡ 00d35ce6-3841-45d9-ad9d-4c3645b2fc51
md"""
An asymmetric kernel
"""

# ╔═╡ 9741e932-7aa6-4237-a32d-f546d0be98d9
kernel2 = Kernel.sobel()[1]

# ╔═╡ f2e108e2-c389-4a72-b3aa-02e4c8c17092
sum(kernel2)

# ╔═╡ 9c90feb8-ec79-11ea-2870-31be5cedff43
md"""
# Function definitions
"""

# ╔═╡ 84e6a57c-edfc-11ea-01a0-157f1df77518
function show_colored_kernel(kernel)
	to_rgb(x) = RGB(max(-x, 0), max(x, 0), 0)
	to_rgb.(kernel) / maximum(abs.(kernel))
end

# ╔═╡ 9424b46a-ee16-11ea-1819-f17ce53e9997
show_colored_kernel(kernel)

# ╔═╡ c69789ac-95b3-4a3c-bfd5-054c0d4092b7
show_colored_kernel(kernel2)

# ╔═╡ 68f2afec-eca2-11ea-0758-2f22c7afdd94
function decimate(arr, ratio=5)
	return arr[1:ratio:end, 1:ratio:end]
end

# ╔═╡ aa3b9bd6-ed35-11ea-1bdc-33861bdbd29a
function shrink_image(image, ratio=5)
	(height, width) = size(image)
	new_height = height ÷ ratio - 1
	new_width = width ÷ ratio - 1
	list = [
		mean(image[
			ratio * i:ratio * (i + 1),
			ratio * j:ratio * (j + 1),
		])
		for j in 1:new_width
		for i in 1:new_height
	]
	reshape(list, new_height, new_width)
end

# ╔═╡ 6d39fea8-ed3c-11ea-3d7c-3f62ca91ce23
begin
	large_image = load("philip.jpg")
	image = shrink_image(large_image, 7)
end

# ╔═╡ 2f446dcc-ee15-11ea-0e78-931ff507b5e5
size(image)

# ╔═╡ 8ac9cfd3-7eaf-4817-b39a-1552c5994e61
prod(size(image))*prod(size(kernel))

# ╔═╡ 14d5b144-ee18-11ea-0080-c187f068c168
image

# ╔═╡ fd81903b-4a1d-4630-be6f-07b54c7b17d3
gray_image = Matrix{Float64}(Gray.(image))

# ╔═╡ 9042690b-d232-42d1-9256-b4d1267cb750
abs.(fft(gray_image))

# ╔═╡ d6f72ca4-b679-4f60-8922-4ce71846621f
mean(gray_image, dims=1)

# ╔═╡ 038b71ab-7d5b-4505-8a70-44297d338313
mean(gray_image[:,3])

# ╔═╡ 160eb236-eca1-11ea-1dbe-47ad61cc9397
function rgb_to_float(color)
    return mean([color.r, color.g, color.b])
end

# ╔═╡ fa3c5074-eca0-11ea-2d2d-bb6bcdeb834c
function fourier_spectrum_magnitudes(img)
    grey_values = rgb_to_float.(img)
    spectrum = fftshift(fft(grey_values))
	return abs.(spectrum)
end

# ╔═╡ e40d807e-ed3a-11ea-2340-7f98bd5d04a2
function plot_1d_fourier_spectrum(img, dims=1)
	spectrum = fourier_spectrum_magnitudes(img)
	plot(centered(mean(spectrum, dims=1)[1:end]))
end

# ╔═╡ deca7295-c0a9-4115-a8d8-98381e69eea6
plot_1d_fourier_spectrum(image)

# ╔═╡ beb6b4b0-eca1-11ea-1ece-e3c9931c9c13
function heatmap_2d_fourier_spectrum(img)
	heatmap(log.(fourier_spectrum_magnitudes(img)))
end

# ╔═╡ 18045956-ee18-11ea-3e34-612133e2e39c
heatmap_2d_fourier_spectrum(image)

# ╔═╡ 58f4754e-ed31-11ea-0464-5bfccf397966
function clamp_at_boundary(M, i, j)
	return M[
		clamp(i, 1, size(M, 1)),
		clamp(j, 1, size(M, 2)),	
	]
end

# ╔═╡ f28af11e-ed31-11ea-2b46-7dff147ccb48
function rolloff_boundary(M, i, j)
	if (1 ≤ i ≤ size(M, 1)) && (1 ≤ j ≤ size(M, 2))
		return M[i, j]
	else
		return 0 * M[1, 1]
	end
end

# ╔═╡ 572cf620-ecb2-11ea-0019-21666a30d9d2
function convolve(M, kernel, M_index_func=clamp_at_boundary)
    height = size(kernel, 1)
    width = size(kernel, 2)
    
    half_height = height ÷ 2
    half_width = width ÷ 2
    
    new_image = similar(M)
	
    # (i, j) loop over the original image
    @inbounds for i in 1:size(M, 1)
        for j in 1:size(M, 2)
            # (k, l) loop over the neighbouring pixels
			new_image[i, j] = sum([
				kernel[k, l] * M_index_func(M, i - k, j - l)
				for k in -half_height:-half_height + height - 1
				for l in -half_width:-half_width + width - 1
			])
        end
    end
    
    return new_image
end

# ╔═╡ 5afed4ea-ee18-11ea-1aa4-abca154b3793
conv_image = convolve(image, kernel)

# ╔═╡ 3b684067-7ba0-4ee9-b412-e066adfc5014
plot_1d_fourier_spectrum(conv_image)

# ╔═╡ 6340c0f8-ee18-11ea-1765-45f4bc140670
heatmap_2d_fourier_spectrum(conv_image)

# ╔═╡ f9280990-40df-4f4a-995b-1094a364af67
conv_image1 = convolve(image, kernel1)

# ╔═╡ 003c098e-0e1a-402c-8873-069cd48a51c1
conv_image2 = convolve(image, kernel2)

# ╔═╡ 018c767d-0247-4c96-9574-701846f0b5db
5*Gray.(abs.(convolve(image, kernel2)))

# ╔═╡ 587092e4-ecb2-11ea-18fc-ad5e9778fb30
box_blur(n) = centered(ones(n, n) ./ (n^2))

# ╔═╡ 991cb9b8-ecb8-11ea-3f80-5d95b2200259
function gauss_blur(n, sigma=0.25)
	kern = gaussian((n, n), sigma)
	return kern / sum(kern)
end

# ╔═╡ 1e8cf4ae-afd6-451e-ad1b-f8577b90b274
sum(gauss_blur(5,1))

# ╔═╡ d1453acd-fb82-41bf-9a3a-81370f031282
show_colored_kernel(box_blur(5))

# ╔═╡ Cell order:
# ╟─42ed52ba-ed34-11ea-26b5-05379824cbc0
# ╠═6d39fea8-ed3c-11ea-3d7c-3f62ca91ce23
# ╠═2f446dcc-ee15-11ea-0e78-931ff507b5e5
# ╠═4c13d558-ee15-11ea-2ed9-c5fb90d93881
# ╠═8ac9cfd3-7eaf-4817-b39a-1552c5994e61
# ╠═af27fb0f-b8c5-413a-8ab9-50583904229c
# ╠═9424b46a-ee16-11ea-1819-f17ce53e9997
# ╠═673f7ac0-ee16-11ea-35d0-cf3da430b843
# ╠═14d5b144-ee18-11ea-0080-c187f068c168
# ╠═deca7295-c0a9-4115-a8d8-98381e69eea6
# ╠═18045956-ee18-11ea-3e34-612133e2e39c
# ╠═1855256d-39e3-4cfd-8d5a-3f5fa849cd73
# ╠═5afed4ea-ee18-11ea-1aa4-abca154b3793
# ╠═3b684067-7ba0-4ee9-b412-e066adfc5014
# ╠═92407bf6-9e4c-4ab8-ab79-d981afb8f8cb
# ╠═d3985849-4b2f-4e34-879c-00d0edfe389d
# ╠═f9280990-40df-4f4a-995b-1094a364af67
# ╠═b1ad3ed5-4c44-45ca-a470-3123ec7f8b5e
# ╠═00d35ce6-3841-45d9-ad9d-4c3645b2fc51
# ╠═9741e932-7aa6-4237-a32d-f546d0be98d9
# ╠═c69789ac-95b3-4a3c-bfd5-054c0d4092b7
# ╠═f2e108e2-c389-4a72-b3aa-02e4c8c17092
# ╠═003c098e-0e1a-402c-8873-069cd48a51c1
# ╠═018c767d-0247-4c96-9574-701846f0b5db
# ╠═6340c0f8-ee18-11ea-1765-45f4bc140670
# ╠═fd81903b-4a1d-4630-be6f-07b54c7b17d3
# ╠═9042690b-d232-42d1-9256-b4d1267cb750
# ╠═d6f72ca4-b679-4f60-8922-4ce71846621f
# ╠═038b71ab-7d5b-4505-8a70-44297d338313
# ╟─9c90feb8-ec79-11ea-2870-31be5cedff43
# ╠═60ec8674-4aa1-4fb4-aaa2-91bf43caa392
# ╠═1ca14906-eca1-11ea-23f6-472ed97d75aa
# ╠═84e6a57c-edfc-11ea-01a0-157f1df77518
# ╠═68f2afec-eca2-11ea-0758-2f22c7afdd94
# ╠═aa3b9bd6-ed35-11ea-1bdc-33861bdbd29a
# ╠═160eb236-eca1-11ea-1dbe-47ad61cc9397
# ╠═fa3c5074-eca0-11ea-2d2d-bb6bcdeb834c
# ╠═e40d807e-ed3a-11ea-2340-7f98bd5d04a2
# ╠═beb6b4b0-eca1-11ea-1ece-e3c9931c9c13
# ╠═58f4754e-ed31-11ea-0464-5bfccf397966
# ╠═f28af11e-ed31-11ea-2b46-7dff147ccb48
# ╠═572cf620-ecb2-11ea-0019-21666a30d9d2
# ╠═587092e4-ecb2-11ea-18fc-ad5e9778fb30
# ╠═991cb9b8-ecb8-11ea-3f80-5d95b2200259
# ╠═1e8cf4ae-afd6-451e-ad1b-f8577b90b274
# ╠═d1453acd-fb82-41bf-9a3a-81370f031282
