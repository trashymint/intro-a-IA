:- use_module(library(lists)).
 
% --- Estado ---
map_size(10).
sword_position(7).
initial_state(state(8, 2, false, false)). % pos caballero, pos bloque, enBloque, tieneEspada
goal(state(_P, _B, _S, true)).
 
% --- Ayudantes ---
distance(X, Y, D) :- D is abs(X - Y).
 
valid_position(P) :-
    integer(P),
    P >= 0,
    map_size(MAX),
    P =< MAX.
 
% --- Movimientos (label -> descripción, opcional) ---
description(caminar_derecha,  "Caminar a la derecha").
description(caminar_izquierda,"Caminar a la izquierda").
description(empujar_derecha,  "Se mueve y empuja el bloque hacia la derecha").
description(empujar_izquierda,"Se mueve y empuja el bloque hacia la izquierda").
description(subir_bloque,     "Se sube al bloque").
description(bajar_bloque,     "Se baja del bloque").
description(agarrar_espada,   "Se obtiene la espada").
 
% accion(EstadoAnterior, Etiqueta, EstadoNuevo)
 
% Caminar (no sobre el bloque)
action(state(P, B, false, S), caminar_derecha, state(DP, B, false, S)) :-
    DP is P + 1,
    valid_position(DP).
 
action(state(P, B, false, S), caminar_izquierda, state(DP, B, false, S)) :-
    DP is P - 1,
    valid_position(DP).
 
% Empujar (debe estar adyacente al bloque)
action(state(P, B, false, S), empujar_derecha, state(DP, DB, false, S)) :-
    distance(P, B, D), D =:= 1,
    DP is P + 1, DB is B + 1,
    valid_position(DP), valid_position(DB).
 
action(state(P, B, false, S), empujar_izquierda, state(DP, DB, false, S)) :-
    distance(P, B, D), D =:= 1,
    DP is P - 1, DB is B - 1,
    valid_position(DP), valid_position(DB).
 
% Subir/bajar bloque
action(state(P, B, false, S), subir_bloque, state(DP, B, true, S)) :-
   distance(P, B, R), R =< 1,
   DP is B,
   valid_position(DP).
 
action(state(P, B, true, S), bajar_bloque, state(P, B, false, S)) :-
   P =:= B.  % estás sobre el bloque
 
% Agarrar espada (sobre el bloque y en la misma celda que la espada)
action(state(P, B, true, false), agarrar_espada, state(P, B, true, true)) :-
    P =:= B,
    sword_position(SW),
    P =:= SW.
 
% --- Heurística ---
h(state(P, B, A, E), H) :-
    sword_position(SW),
    distance(P, B, DIST_PB),
    distance(B, SW, DIST_BSW),
    H1 is 10 ** DIST_PB,
    H2 is 5 ** DIST_BSW,
    (A == true -> H3 = 0 ; H3 = 1),
    (E == true -> H4 = 0 ; H4 = 1),
    H is H1 + H2 + H3 + H4.
 
% --- Seleccionar mejor de la Open List ---
select_best([Head|Rest], Best, RestWithoutBest) :-
    best_of(Rest, Head, Best),
    select(Best, [Head|Rest], RestWithoutBest).
 
best_of([], Best, Best).
best_of([node(S1, P1, G1, H1)|Rest], node(S2, P2, G2, H2), Best) :-
    F1 is G1 + H1,
    F2 is G2 + H2,
    ( F1 < F2
    -> best_of(Rest, node(S1, P1, G1, H1), Best)
    ;  best_of(Rest, node(S2, P2, G2, H2), Best)
    ).
 
% --- Expandir ---
possible_moves(node(S, A, G, _), Moves) :-
    findall(node(S2, [Move|A], G2, H2),
            ( action(S, Move, S2),
              G2 is G + 1,
              h(S2, H2)
            ),
            Moves).
 
% --- Filtrar visitados ---
remove_visited([], Visited, ToVisit, ToVisit, Visited).
remove_visited([node(S, A, G, H)|Rest], Visited, ToVisit, NewToVisit, NewVisited) :-
    ( member(S, Visited) ->
        remove_visited(Rest, Visited, ToVisit, NewToVisit, NewVisited)
    ;   remove_visited(Rest, [S|Visited], [node(S, A, G, H)|ToVisit], NewToVisit, NewVisited)
    ).
 
% --- A* ---
astar(ToVisit, _Visited, Path) :-
    select_best(ToVisit, node(S, P, _G, _H), _),
    goal(S), !,
    reverse(P, Path).
 
astar(ToVisit, Visited, Path) :-
    select_best(ToVisit, node(S, P, G, H), RestOpen),
    possible_moves(node(S, P, G, H), Moves),
    remove_visited(Moves, [S|Visited], RestOpen, NewToVisit, NewVisited),
    astar(NewToVisit, NewVisited, Path).
 
% --- Correr ---
run(Path) :-
    initial_state(S),
    h(S, H),
    astar([node(S, [], 0, H)], [], Path).
 