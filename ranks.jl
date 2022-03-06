include("src/WordleBot.jl")

using .WordleBot

sublist, full_list = load_words("data/solutions.txt", "data/candidates.txt")
words = sublist
solutions = sublist

## frequencies
weights = get_frequencies(words, fill('_', 5))
scores = score_frequency(words, fill('_', 5), weights)
ranks=sort(scores, by=x->x[2], rev=true)

println("frequencies")
display(ranks)
println("")

## frequencies by letter position
weights = get_frequencies_position(words, fill('_', 5))
scores = score_frequency_position(words, fill('_', 5), weights)
ranks=sort(scores, by=x->x[2], rev=true)

println("frequencies by letter position")
display(ranks)
println("")

## entropy
scores = score_entropy(words, words)
ranks=sort(scores, by=x->x[2], rev=true)

println("entropy")
display(ranks)
