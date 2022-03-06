## Wordle game
#https://www.powerlanguage.co.uk/wordle/

@enum Hint CORRECT PRESENT ABSENT

function load_words(solutions_path, candidates_path)
    solutions = String[]
    open(solutions_path) do file
        for line in eachline(file)
           push!(solutions, line) 
        end
    end
    candidates = copy(solutions)
    open(candidates_path) do file
        for line in eachline(file)
           push!(candidates, line) 
        end
    end
    solutions, candidates
end

function verify(candidate, solution)
    response = fill(ABSENT, length(solution))
    solution = collect(solution)
    # correct takes precedence over present
    for (idx, (c1, c2)) in enumerate(zip(candidate, solution))
        if (c1 == c2)
            solution[idx] = '_' # prevent double counting 
            response[idx] = CORRECT
        end
    end
    for (idx, c1) in enumerate(candidate)
        if (response[idx] == ABSENT) & (c1 in solution)
            idx_sol = findfirst(collect(solution) .== c1)
            solution[idx_sol] = '_' # prevent double counting 
            response[idx] = PRESENT
        end
    end
    response
end

function emojify(hints::Vector{Hint})
    mapping = Dict(
        CORRECT => "🟩",
        PRESENT => "🟨",
        ABSENT => "⬛"
    )
    join(map(x->mapping[x], hints), "")
end

function print_response(word::String, response::Vector{Hint})
    println(word, " ", emojify(response))
end
