
function encode_base3(hints::Vector{Hint})
    n = length(hints) - 1 
    ans = 0 
    for h in hints
        x = (h == CORRECT) ? 2 : (h == PRESENT) ? 1 : 0
        ans += x * (3^n) 
        n -= 1
    end
    ans
end

function decode_base3(num::Int, n::Int=5)
    hints = Hint[]
    base = 3^(n-1)
    for idx in 1:n
        quotient = floor(Int, num/base)
        h = (quotient == 2) ? CORRECT : (quotient == 1) ? PRESENT : ABSENT
        push!(hints, h)
        num = num % base
        base /= 3
    end
    hints
end