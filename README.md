## Wordle Solver

Solver [Wordle](https://www.nytimes.com/games/wordle/index.html).

## Scripts

- `run_bot.jl`: run a simulation of the bot against every word in the solutions list.
- `solve.jl`: play along with a game of Wordle; enter the responses into the REPL. The solver will rank the candidates according to the metric chosen but this ranking is only a suggestion.
- `distributions.jl`: data analysis of the words.
- `initial_guesses.jl`: brute force optimization: play all games with every word to determine the best starting word.
- `permutations.jl`: which words are permutations of each other.


## Summary of solvers

Parameters
- For frequency: `min_guess=1`
- For reveals: `min_guess=3` - 3 words with same letters e.g. rider, drier, dried
- For entropy: `min_guess=2` - 2 bits

Cheat mode: `n_solutions=n_candidates=2315`:
<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">solver</th>
    <th class="tg-0pky">initial</td>
    <th class="tg-0pky">avg moves</th>
    <th class="tg-0lax">max moves</th>
    <th class="tg-0lax">losses</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">frequency</td>
    <td class="tg-0pky">alert</td>
    <td class="tg-0pky">3.6713</td>
    <td class="tg-0lax">8</td>
    <td class="tg-0lax">17</td>
  </tr>
  <tr>
    <td class="tg-0pky">frequency+position</td>
    <td class="tg-0pky">slate</td>
    <td class="tg-0pky">3.6864</td>
    <td class="tg-0lax">8</td>
    <td class="tg-0lax">15</td>
  </tr>
    <tr>
    <td class="tg-0pky">reveals</td>
    <td class="tg-0pky">slate</td>
    <td class="tg-0pky">3.7590</td>
    <td class="tg-0lax">7</td>
    <td class="tg-0lax">2</td>
  </tr>
  </tr>
    <tr>
    <td class="tg-0pky">entropy</td>
    <td class="tg-0pky">raise</td>
    <td class="tg-0lax">3.5529</td>
    <td class="tg-0pky">6</td>
    <td class="tg-0lax">0</td>
  </tr>
</tbody>
</table>

Normal mode: `n_solutions=2315` and `n_candidates=12972`:
<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">solver</th>
    <th class="tg-0pky">initial</td>
    <th class="tg-0pky">avg moves</th>
    <th class="tg-0lax">max moves</th>
    <th class="tg-0lax">losses</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">frequency</td>
    <td class="tg-0lax">arose</td>
    <td class="tg-0lax">4.5274</td>
    <td class="tg-0lax">13</td>
    <td class="tg-0lax">146</td>
  </tr>
  <tr>
    <td class="tg-0pky">frequency+position</td>
    <td class="tg-0lax">sores</td>
    <td class="tg-0lax">4.8030</td>
    <td class="tg-0lax">12</td>
    <td class="tg-0lax">213</td>
  </tr>
    <tr>
    <td class="tg-0pky">reveals</td>
    <td class="tg-0lax">sores</td>
    <td class="tg-0lax">4.8323</td>
    <td class="tg-0lax">12</td>
    <td class="tg-0lax">122</td>
  </tr>
  </tr>
    <tr>
    <td class="tg-0pky">entropy</td>
    <td class="tg-0lax">tares</td>
    <td class="tg-0lax">4.0523</td>
    <td class="tg-0lax">6</td>
    <td class="tg-0lax">0</td>
  </tr>
</tbody>
</table>

Entropy solution in 1.5 hours. Distribution: 0 5 410 1402 455 43

General mode: `n_solutions=n_candidates=12972`:
<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">solver</th>
    <th class="tg-0pky">initial</td>
    <th class="tg-0pky">avg moves</th>
    <th class="tg-0lax">max moves</th>
    <th class="tg-0lax">losses</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">frequency</td>
    <td class="tg-0lax">arose</td>
    <td class="tg-0lax">4.8553</td>
    <td class="tg-0lax">17</td>
    <td class="tg-0lax">1608</td>
  </tr>
  <tr>
    <td class="tg-0pky">frequency+position</td>
    <td class="tg-0lax">sores</td>
    <td class="tg-0lax">5.1085</td>
    <td class="tg-0lax">16</td>
    <td class="tg-0lax">1997</td>
  </tr>
    <tr>
    <td class="tg-0pky">reveals</td>
    <td class="tg-0lax">sores</td>
    <td class="tg-0lax">5.2347</td>
    <td class="tg-0lax">15</td>
    <td class="tg-0lax">2407</td>
  </tr>
  </tr>
    <tr>
    <td class="tg-0pky">entropy</td>
    <td class="tg-0lax">tares</td>
    <td class="tg-0lax">?</td>
    <td class="tg-0lax">?</td>
    <td class="tg-0lax">?</td>
  </tr>
</tbody>
</table>

