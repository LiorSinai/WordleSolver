include("src/WordleBot.jl")

using .WordleBot
using Printf

function validate_candidate(candidate::String, nletters::Int)
    if length(candidate) != nletters
        println("candidate must be $nletters letters")
        return false
    end
    true
end

function validate_response(response::String, nletters::Int, response_map::Dict)
    if length(response) != nletters
        println("response must have $nletters letters")
        return false
    elseif !all(map(x->haskey(response_map, x), collect(response)))
        println("Keys must be in \"CPAcpa🟩🟨⬛\"")
        return false
    end
    true
end

function display_ranks(ranks, ranks_candidates, nshow=20)
    nwords = length(ranks)
    ncandidates = length(candidates)
    println(" all words (n=$nwords)", " "^(8-length(string(nwords))), "candidates (n=$ncandidates)")
    for idx in 1:min(nshow, nwords)
        s = @sprintf("%2d %s %.5f", idx, ranks[idx][1], ranks[idx][2])
        if idx <= ncandidates
            s *= @sprintf("       %s %.5f", ranks_candidates[idx][1], ranks_candidates[idx][2])
        end
        println(s)
    end
end

response_map = Dict(
    'C' => CORRECT,
    'P' => PRESENT,
    'A' => ABSENT,
    'c' => CORRECT,
    'p' => PRESENT,
    'a' => ABSENT,
    '🟩' => CORRECT,
    '⬛' => ABSENT,
    '🟨' => PRESENT,
)

sublist, full_list = load_words("data/solutions.txt", "data/candidates.txt")
words = sublist

nletters = 5
max_moves = 6
ncandidates_show = 20
clue = fill('_', nletters)
wrongpos = [Char[] for i in 1:nletters]
eliminated = Set{Char}() 
candidates = Set(words)

for i in 1:max_moves
    is_valid_candidate = false
    is_valid_response = false

    candidate = ""
    response_BGY = ""
    while !is_valid_candidate
        print("Enter candidate: ")
        candidate = readline() 
        is_valid_candidate = validate_candidate(candidate, nletters)
    end
    while !is_valid_response
        print("Enter response:  ")        
        response_BGY = readline()
        is_valid_response = validate_response(response_BGY, nletters, response_map)
    end
    
    response = map(x->response_map[x], collect(response_BGY))
    interpret!(response, candidate, clue, wrongpos, eliminated)
    # filter candidates
    filter_present!(candidates, clue, wrongpos)
    filter_eliminated!(candidates, eliminated) 
    pattern = clue_regex(clue, wrongpos, eliminated)
    filter!(w -> !isnothing(match(Regex(pattern), w)), candidates)

    if length(candidates) == 1
        println("final candidate: ", collect(candidates)[1])
        break
    elseif  isempty(candidates)
        print("no candidates left")
        break
    end

    # select next candidate
    #weights = get_frequencies(candidates, clue)
    #scores = score_frequency(candidates, clue, weights)
    #weights = get_frequencies_position(candidates, clue)
    #scores = score_frequency_position(candidates, clue, weights)
    #scores = score_new(words, candidates, clue, wrongpos)
    scores = score_entropy(words, candidates)

    ranks = sort(scores, by=x->(-x[2], x[1]))
    ranks_candidates = [s for s in ranks if s[1] in candidates]
    display_ranks(ranks, ranks_candidates, ncandidates_show)
    println("")
end
