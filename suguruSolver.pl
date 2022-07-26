:- use_module(library(clpfd)).

% Verdadeiro quando Rows corresponde ao Suguru resolvido.
solved(Suguru, Rows) :-
  % Regions Check
  append(Suguru, FlatS),
  sort(1, @>=, FlatS, SortedS),
  group_pairs_by_key(SortedS, Regions),
  pairs_values(Regions, RegionsValues),
  maplist(interval, RegionsValues),
  maplist(all_distinct, RegionsValues),
  
  % Rows Check
  maplist(pairs_values, Suguru, Rows),
  maplist(same_length, Rows, Rows),
  applyAdj(Rows).

% Verdadeiro quando cada conjunto de 4 células, em duas linhas, são diferentes.
adj([_ | []], [_ | []]) :- !.
adj([N1, N2 | Ns1], [N3, N4 | Ns2]) :- all_distinct([N1, N2, N3, N4]), adj([N2 | Ns1], [N4 | Ns2]).

% Verdadeiro quando adj é verdade em um tabuleiro.
applyAdj([_ | []]) :- !.
applyAdj([H1, H2 | Rst]) :-
  call(adj, H1, H2),
  applyAdj([H2 | Rst]).

% Verdadeiro quando o conteúdo da lista L está dentro do intervalo 1 <-> length(L).
interval(L) :-
  length(L, T),
  L ins 1..T.

% Exemplo de suguru 6 x 6, com 8 regiões (Suguru Nº 1).
suguru(1, [[a-4, a-_, b-_, c-_, c-_, c-_],
           [a-_, b-_, b-_, b-_, c-_, d-_],
           [a-_, e-_, b-4, f-_, c-_, d-1],
           [e-_, e-_, f-_, f-2, f-_, d-_],
           [e-5, g-_, g-_, f-3, h-5, d-_],
           [e-_, h-_, h-_, h-_, h-_, d-_]]).

% Exemplo de suguru 8 x 8, com 15 regiões (Suguru Nº 12).
suguru(2, [[a-2, b-_, c-_, d-_, d-_, d-_, d-_, e-_],
           [a-_, c-_, c-_, c-_, d-_, f-5, e-_, e-1],
           [a-_, a-_, c-_, g-_, f-_, f-_, f-_, e-_],
           [a-_, h-3, g-5, g-_, g-_, f-_, i-_, e-_],
           [h-_, h-_, j-_, j-_, g-_, k-4, i-_, i-_],
           [h-_, l-5, j-_, m-5, k-_, k-_, k-_, i-3],
           [l-_, l-4, l-_, m-3, m-_, k-_, n-2, i-5],
           [o-_, l-_, m-_, m-_, n-_, n-_, n-_, n-_]]).

% Exemplo de suguru 10 x 10, com 18 regiões (Suguru Nº 160).
suguru(3, [[a-6, b-2, b-5, b-3, b-_, b-7, b-_, c-7, d-2, d-_],
           [a-5, b-4, c-_, c-2, c-1, c-_, c-3, c-_, d-_, e-1],
           [a-3, a-_, f-3, f-_, g-5, g-_, g-2, g-_, d-_, e-7],
           [a-_, a-4, f-2, f-6, f-_, g-_, g-_, g-4, d-_, e-4],
           [h-1, h-5, f-_, f-_, i-1, i-4, i-_, i-2, e-6, e-2],
           [h-7, h-_, h-6, h-_, h-3, i-_, i-3, j-_, e-3, e-_],
           [k-_, l-4, l-_, l-_, l-_, m-5, m-2, n-_, n-_, n-_],
           [l-_, l-_, o-_, o-7, o-2, m-_, m-_, n-5, n-_, p-5],
           [o-_, o-_, o-4, q-_, q-4, q-7, m-_, m-_, m-6, p-_],
           [o-5, r-_, r-_, q-_, q-6, q-_, q-5, p-_, p-3, p-2]]).

% Exemplo de suguru vazio 6 x 6, com 8 regiões (Suguru Nº 1).
suguru(4, [[a-_, a-_, b-_, c-_, c-_, c-_],
           [a-_, b-_, b-_, b-_, c-_, d-_],
           [a-_, e-_, b-_, f-_, c-_, d-_],
           [e-_, e-_, f-_, f-_, f-_, d-_],
           [e-_, g-_, g-_, f-_, h-_, d-_],
           [e-_, h-_, h-_, h-_, h-_, d-_]]).

% Exemplo de suguru vazio 7 x 6, com 8 regiões.
suguru(5, [[a-_, a-_, b-_, c-_, c-_, c-_],
           [a-_, b-_, b-_, b-_, c-_, d-_],
           [a-_, e-_, b-_, f-_, c-_, d-_],
           [e-_, e-_, f-_, f-_, f-_, d-_],
           [e-_, g-_, g-_, f-_, h-_, d-_],
           [e-_, h-_, h-_, h-_, h-_, d-_],
           [e-_, h-_, h-_, h-_, h-_, d-_]]).

% Exemplo de suguru inválido 6 x 6, com 8 regiões (Suguru Nº 1).
suguru(6, [[a-_, a-_, b-_, c-_, c-_, c-_],
           [a-_, b-1, b-1, b-_, c-_, d-_],
           [a-_, e-_, b-_, f-_, c-_, d-_],
           [e-_, e-_, f-_, f-_, f-_, d-_],
           [e-_, g-_, g-_, f-_, h-_, d-_],
           [e-_, h-_, h-_, h-_, h-_, d-_]]).

% Consulta -
% Sem backtracking:
% suguru(1, S), solved(S, Rows), maplist(portray_clause, Rows).
% 
% Com backtracking:
% suguru(4, S), solved(S, Rows), maplist(labeling([ff]), Rows), maplist(portray_clause, Rows).