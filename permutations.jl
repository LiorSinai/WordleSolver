include("src/WordleBot.jl")

using .WordleBot

sublist, full_list = load_words("data/solutions.txt", "data/candidates.txt")
words = sublist

sort!(words)
matched = Set{String}()
for word in words
    if word in matched
        continue
    end 
    n = 0
    chars = Set(word)
    if length(chars) < 5
        continue
    end
    perms = String[]
    for other in words
        if word == other
            continue
        end
        if Set(other) == chars 
            push!(perms, other)
            push!(matched, other)
            push!(matched, word)
        end
    end
    if length(perms) >= 2
        println(word, ", ", join(perms, ", "))
    end
end
