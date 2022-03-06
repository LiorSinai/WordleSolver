module WordleBot

using DataStructures

export load_words, verify, 
    Hint, CORRECT, PRESENT, ABSENT

export filter_with_clues!, filter_present!, filter_eliminated!, clue_regex,
    load_frequencies, get_frequencies, get_frequencies_position,
    score_frequency, score_frequency_position, score_new,  
    score_entropy, entropy_matrix

export play_game, interpret!

include("wordle.jl")
include("solver.jl")

function play_game(words, solution::String; 
    num_moves=6, 
    candidate="slate", 
    verbose=true,
    min_guess=1
    )
    clue = fill('_', length(solution))
    wrongpos = [Char[] for i in 1:length(solution)]
    eliminated = Set{Char}()
    
    candidates = Set(words)

    won = false
    moves = 0
    for m in 1:num_moves
        moves += 1
        response = verify(candidate, solution)
        verbose && print_response(candidate, response)
        if all(response .== CORRECT)
            won = true
            break
        end
        interpret!(response, candidate, clue, wrongpos, eliminated)
        # filter candidates
        filter_present!(candidates, clue, wrongpos)
        filter_eliminated!(candidates, eliminated) 
        pattern = clue_regex(clue, wrongpos, eliminated)
        filter!(w -> !isnothing(match(Regex(pattern), w)), candidates)
        if isempty(candidates) 
            break
        elseif (length(candidates) <= min_guess) 
            candidate = collect(candidates)[1]
        else
            #weights = get_frequencies(candidates, clue)
            #scores = score_frequency(candidates, clue, weights)
            #weights = get_frequencies_position(candidates, clue)
            #scores = score_frequency_position(candidates, clue, weights)
            #scores = score_new(words, candidates, clue, wrongpos)
            scores = score_entropy(words, candidates)
            candidate = minimum(x->(-x[2], x[1]), scores)[2]
        end
    end
    won, moves
end


function interpret!(result, candidate,
    clue::Vector{Char},
    wrongpos::Vector{Vector{Char}},
    eliminated::Set{Char}
    )
    # tally correct first, because this might affect if char in clue
    for (idx, hint) in enumerate(result) 
        if (hint == CORRECT)
            clue[idx] = candidate[idx]
        end
    end
    for (idx, hint) in enumerate(result) 
        char = candidate[idx]
        # if char is present before but now marked absent, then have too many of the letter => wrongpos
        if (hint == PRESENT) || ((hint == ABSENT) & ((char in clue) || (char in vcat(wrongpos...))))
            push!(wrongpos[idx], char)
        elseif (hint == ABSENT)
            push!(eliminated, char)
        end
    end
end

end