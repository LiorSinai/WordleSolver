include("src/WordleBot.jl")

using .WordleBot
using Printf

sublist, full_list = load_words("data/solutions.txt", "data/candidates.txt")
words = sublist
solutions = sublist
nwords = length(words)

total_wins = zeros(nwords)
avg_moves = zeros(nwords)
max_moves = zeros(Int, nwords)
losses = zeros(Int, nwords)

scores = score_entropy(words, words)
ranks = sort(scores, by=x->x[2], rev=true)

elapsed_time = time_ns()
for (idx0, guess) in enumerate(ranks[1:100])
    println("$idx0 $guess")

    wins = fill(false, nwords)
    moves = zeros(Int, nwords)
    for (idx, word) in enumerate(solutions) 
        if idx % 100 == 0
            print(".")
        end
        wins[idx], moves[idx] = play_game(words, word, verbose=false, candidate=guess[1], num_moves=20, min_guess=2)
    end
    print("\n")

    wins_ratio = sum(wins)/nwords
    losses_ = sum(moves .> 6)
    avg_moves_ = sum(moves[wins .== true])/sum(wins)
    max_move = maximum(moves)
    @printf("wins: %.2f%%, losses: %d, avg_moves: %.4f, max_move: %d\n", 100*wins_ratio, losses_, avg_moves_, max_move)

    total_wins[idx0] = sum(wins)
    avg_moves[idx0] = avg_moves_ 
    max_moves[idx0] = max_move
    losses[idx0] = losses_

    open("outputs/initial_guess_entropy.tsv", "a") do file
        @printf(file, "%s\t%d\t%.5f\t%d\n", guess[1], max_moves[idx0], avg_moves[idx0], losses[idx0])
    end
end

elapsed_time = (time_ns() - elapsed_time) / 1e9
minutes = floor(elapsed_time / 60)
seconds = elapsed_time - 60*minutes
@printf("time taken: %.0fmin %.4fs\n", minutes, seconds)

# words = String[]
# avg_moves = Float64[]
# max_moves = Int[]
# losses = Int[]
# open("initial_guess.tsv", "r") do file
#     readline(file)
#     for line in eachline(file)
#         data = split(line, ('\t', ' '))
#         push!(words, data[1])
#         push!(max_moves, parse(Int, data[2]))
#         push!(avg_moves, parse(Float64, data[3]))
#         push!(losses, parse(Int, data[4]))
#     end
# end