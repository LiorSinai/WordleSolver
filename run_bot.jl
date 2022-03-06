include("src/WordleBot.jl")

using .WordleBot
using Printf

sublist, full_list = load_words("data/solutions.txt", "data/candidates.txt")
words = sublist
solutions = sublist

responses = entropy_matrix(words)

nwords = length(solutions)
wins = fill(false, nwords)
moves = zeros(Int, nwords)
start_time = time_ns()
for (idx, solution) in enumerate(solutions) 
    wins[idx], moves[idx] = play_game(
        words, solution, responses,
        verbose=false, candidate="raise", num_moves=20, min_guess=2
        )
    if idx % 10 == 0
        println("$idx $solution $(moves[idx])")
    end
end
@printf("%.4fs\n", (time_ns() - start_time) / 1e9)

wins_ratio = sum(wins)/nwords
losses = sum(moves .> 6)
avg_moves = sum(moves[wins .== true])/sum(wins)
@printf("wins: %.4f%%, losses: %d, avg_moves: %.4f\n", 100*wins_ratio, losses, avg_moves)

print(words[wins .== false])