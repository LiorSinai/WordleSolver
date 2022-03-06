## Solver

function filter_present!(words, clue::Vector{Char}, wrongpos::Vector{Vector{Char}})
    present = union(
        Set([c for c in clue if c != '_']),
        Set(vcat(wrongpos...))
    )
    for c in present
        filter!(w -> occursin(c, w), words)
    end
end

function filter_eliminated!(words, eliminated::Set{Char})
    for c in eliminated
        filter!(w -> !occursin(c, w), words)
    end
end

function clue_regex(clue::Vector{Char}, wrongpos::Vector{Vector{Char}}, eliminated::Set{Char})
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    pattern = ""
    for i in 1:length(clue)
        if clue[i] === '_'
            letters_i = [c for c in alphabet if !((c in wrongpos[i]) || (c in eliminated))]
            pattern *= "[" * join(letters_i, "") * "]"
        else
           pattern *= clue[i]
        end
    end
    pattern
end


"""
    score_frequency(words, clue, weights)

Score words by the frequency of the missing letters in clue. Weights should not be ones.
Word list should already be filtered. 
"""
function score_frequency(words, clue::Vector{Char}, weights=ones(26))
    scores = Tuple{String, Float64}[]
    idxs = (1:length(clue))[clue .== '_']
    for word in words
        score = 0.0 
        for c in Set(word[idxs])
            score += 1.0 * weights[Int(c) - 96]
        end
        push!(scores, (word, score))
    end
    scores
end

"""
    score_new(words, candidates, clue, weights)

Score words by the number of new letters they can reveal in candidates that are not in clue.
"""
function score_new(words, candidates, clue::Vector{Char},  wrongpos::Vector{Vector{Char}}, weights=ones(26))
    scores = Tuple{String, Float64}[]
    idxs = (1:length(clue))[clue .== '_']
    letters = Set(join([word[idxs] for word in candidates], ""))
    letters = setdiff(letters, clue, vcat(wrongpos...))
    for word in words
        score = 0.0
        for c in Set(word)
            if (c in letters)
                score += 1.0 * weights[Int(c) - 96]
            end
        end
        push!(scores, (word, score))
    end
    scores
end


"""
    score_frequency_position(words, clue, weights)

Score words by letter frequency in each position.
Word list should already be filtered. 
"""
function score_frequency_position(words, clue::Vector{Char}, weights)
    scores = Tuple{String, Float64}[]
    for word in words
        score = 0.0
        idxs = (1:length(clue))[clue .== '_']
        for idx in idxs
            score += 1.0 * weights[Int(word[idx]) - 96, idx]
        end
        push!(scores, (word, score))
    end
    scores
end


"""
    score_entropy(words, candidates)

Score words by expected entropy.
Word list should already be filtered. 
"""
function score_entropy(words, candidates)
    scores = Tuple{String, Float64}[]
    nwords = length(candidates)
    for word in words
        responses = DefaultDict{Vector{Hint}, Float64}(0.0)
        for solution in candidates
            r = verify(word, solution)
            responses[r] += 1.0
        end
        probs = values(responses) ./ nwords
        entropy = sum(-probs .* log2.(probs))
        push!(scores, (word, entropy))
    end
    scores
end

"""
    get_frequencies(words, clue)

Calculate letter frequencies per word based on words and a clue.
The words list should be filtered first based on the clues.
"""
function get_frequencies(words, clue::Vector{Char})
    frequencies = zeros(26)
    idxs = (1:length(clue))[clue .== '_']
    for word in words
        for c in Set(word[idxs])
            frequencies[Int(c) - 96] += 1.0
        end
    end
    frequencies .= frequencies./ maximum(frequencies)    
    frequencies
end

"""
get_frequencies_position(words, clue)

Calculate letter frequencies based on words and a clue per position.
The words list should be filtered first based on the clues.
"""
function get_frequencies_position(words, clue::Vector{Char})
    frequencies = zeros(26, length(clue))
    idxs = (1:length(clue))[clue .== '_']
    for word in words
        for idx in idxs
            frequencies[Int(word[idx]) - 96, idx] += 1.0
        end
    end
    frequencies .= frequencies./ maximum(frequencies)    
    frequencies
end
