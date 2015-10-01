%% @author sunils
%% @doc @todo Add description to sl.

-module(sl).

%% API functions

-export([start/0]).

start() -> 
    Players = [{p1, 0}, {p2, 0}, {p3, 0}, {p4, 0}],
    play(Players, []).

%% Internal functions

play([Head|Rest], Updated_list) ->
    {P, Position} = dice_roll(Head),
    case someone_has_won({P, Position}) of
        true -> io:format("~w has won the game!! ~n", [P]);
        false -> 
            case Rest of
                [] -> play(lists:append(Updated_list, [{P, Position}]), []); %% all the players got his turn, so now update original list with the updated one.
                 _ -> play(Rest, lists:append(Updated_list, [{P, Position}])) %% next user turn
            end
    end
.

dice_roll({P, Position}) ->
    Rolled = rand:uniform(6),
    io:format("~w is at position ~w and rolled : ~w ~n", [P, Position, Rolled]),
    New_position = check_snakes_ladders({P, Position}, Position + Rolled),
    if
        New_position > 100 -> 
            io:format("~w cannot move from ~w to ~w. ~n", [P, Position, New_position]),
            {P, Position};
        New_position =< 100 -> {P, New_position}
    end.

check_snakes_ladders({P, Position}, New_position) ->
    Snakes = #{ 15 => 3, 20 => 5, 58 => 30, 80 => 6, 98 => 10 },
    Ladders = #{ 6 => 23, 12 => 25, 50 => 92, 60 => 76 },
    S = maps:get(New_position, Snakes, 0),
    L = maps:get(New_position, Ladders, 0),
    if
        L == 0, S == 0 -> New_position;
        L > 0 -> 
            io:format("~w@~w Moving from ~w -> ~w ======*Ladder*====== ~n", [P, Position, New_position, L]),
            L;
        S > 0 -> 
            io:format("~w@~w Moving from ~w -> ~w ------*Snake*------- ~n", [P, Position, New_position, S]),
            S
    end.

someone_has_won({P, Position}) -> 
    if
        Position == 100 -> true;
        Position < 100 -> false
    end.
