using Plots
using DataStructures
include("src/wordle.jl")

solutions, candidates = load_words("data/solutions.txt", "data/candidates.txt")
alphabet = "abcdefghijklmnopqrstuvwxyz"

##### ------------ single letter frequencies ------------ #####
words = candidates
frequencies = zeros(Int, 26)
for word in words
    for c in Set(word)
        frequencies[Int(c) - 96] += 1
    end
end

idxs = sortperm(frequencies, rev=true)
for idx in idxs
    println("$(alphabet[idx]) $(frequencies[idx])")
end

x = collect(alphabet)[idxs]
y = frequencies[idxs]
bar(x, y ./sum(y), 
    xticks=(0.5:25.5, x), 
    label="",
    ylabel="frequency/word",
    xlabel="letters", 
    title="Wordle candidates - letter frequencies"
)  

##### ------------ letter+position frequencies ------------ #####
words = solutions
frequencies = zeros(Int, 26, 5)
for word in words
    for (idx, c) in enumerate(word)
        frequencies[Int(c) - 96, idx] += 1
    end
end

idxs = sortperm(vec(sum(frequencies, dims=2)), rev=true)

heatmap(transpose(frequencies[idxs, :])[5:-1:1, :], 
    ylims=(0.5,5.5),
    aspectratio=:equal,
    xticks=(1:26, collect(alphabet)[idxs]), yticks=(1:5, 5:-1:1),
    xlabel="letters", ylabel="positions", title="Wordle candidates - letter frequency",
    )

p2 = heatmap(frequencies[end:-1:1, :], 
    xlims=(0.5, 5.5),
    aspectratio=:equal,
    yticks=(1:26, collect(alphabet)[end:-1:1]),
    ylabel="letters", xlabel="positions", title="solutions",
    #colorbar_title="frequency"
    )

##### ------------ entropy ------------ #####
words = solutions
nwords = length(words)
entropies = zeros(length(words))

responses = Dict()
for (idx, candidate) in enumerate(words)
    if idx % 100 == 0 
        println("$idx $candidate")
    end
    responses_ = DefaultDict{Vector{Hint}, Float64}(0.0)
    for solution in words
        r = verify(candidate, solution)
        responses_[r] += 1.0
    end
    probs = values(responses_) ./ nwords
    entropies[idx] = sum(-probs .* log2.(probs))
end

idxs = sortperm(entropies, rev=true)
for (rank, idx) in enumerate(idxs[1:100])
    println("$rank $(words[idx]) $(entropies[idx])")
end

xticks_ = vcat(1:300:nwords, nwords)
plot(1:nwords, entropies[idxs], # ylims=(0, 6.4),
    ylabel="E[entropy] (bits)", xlabel="words", title="Expected entropy over words",
    label="",
    xticks=(xticks_, ["$i\n$(words[idxs[i]])" for i in xticks_])
)

probs = values(responses["fuzzy"]) ./ nwords
bar(sort(probs, rev=true), label="fuzzy")

probs = values(responses["audio"]) ./ nwords
bar!(sort(probs, rev=true), label="audio", alpha=0.7)

probs = values(responses["raise"]) ./ nwords
bar!(sort(probs, rev=true), label="raise", alpha=0.7)
plot!(xlabel="reponses", ylabel="probability", title="Entropy distributions of words")
