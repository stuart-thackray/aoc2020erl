%% @author stuart
%% @doc @todo Add description to day4.


-module(day4).


-define(REQUIRED, ["byr", "iyr","eyr","hgt",
                   "hcl","ecl", "pid", "cid"]).

-define(BLANK_MAP, #{expected => 
                     ?REQUIRED
                    }).
%% ====================================================================
%% API functions, 
%% ====================================================================
-export([p1/0,
         p2/0
        ]).

p1() ->
    Input = read_input(), 
    Passports = split_records(Input, <<>>),
    PassportsMaps = parse_to_maps(Passports),
    ValidPassports = 
    [
     is_valid_passport(?REQUIRED, Map, []) ||
     Map <- PassportsMaps], 
    length([X|| X<- ValidPassports,
                X == valid
           ]).

p2() ->
    Input = read_input(), 
    Passports = split_records(Input, <<>>),
    PassportsMaps = parse_to_maps(Passports),
    All = [is_valid_passport_p1(?REQUIRED, Map, []) ||
           Map <- PassportsMaps], 
    P1Valid =[Y|| {_,Y} <-  [X || X <- All, 
                                  is_tuple(X)]],
    length([X || X <- [valid_information_contatined(?REQUIRED, Map) || Map <- P1Valid],
                 X == valid]).


%% ====================================================================
%% Internal functions
%% ====================================================================
valid_information_contatined(_, Map) ->
    try 
        %% Let if fail. 
        is_byr(maps:get("byr", Map)), 
        is_iyr(maps:get("iyr", Map)),
        is_eyr(maps:get("eyr", Map)), 
        is_hgt(maps:get("hgt", Map)),
        is_hcl(maps:get("hcl", Map)),
        is_ecl(maps:get("ecl", Map)),
        is_passid(maps:get("pid", Map)), 
        valid
    catch _:_:_ -> invalid
    end.

is_byr(Str) when length(Str) == 4 ->
    case list_to_integer(Str) of 
        X when X>= 1920,X =< 2002 ->
            ok
    end.

is_iyr(Str) when length(Str) == 4 ->
    case list_to_integer(Str) of 
        X when X>= 2010,X =< 2020 ->
            ok
    end.
is_eyr(Str) when length(Str) == 4 ->
    case list_to_integer(Str) of 
        X when X>= 2020,X =< 2030 ->
            ok
    end.

is_hgt(Str) ->
    case string:reverse(Str) of 
        [$m, $c|Num] ->
            case list_to_integer(string:reverse(Num)) of
                X when X>= 150,X =< 193 -> ok
            end;
        [$n, $i|Num]  ->
            case list_to_integer(string:reverse(Num)) of
                X when X>= 59,X =< 76 -> ok
            end
    end.

is_ecl(X) when X == "amb";
               X == "blu";
               X == "brn";
               X == "gry";
               X == "grn";
               X == "hzl";
               X == "oth"
               ->
    ok.

is_passid(X) when length(X) == 9 ->
    list_to_integer(X).

is_hcl( [$#|Tail]) when length(Tail) == 6 -> 
    valid_hcl_chrs(Tail).

valid_hcl_chrs([]) ->
    ok;
valid_hcl_chrs([E|Tail]) when 
      E >= $0, E =< $9

      ->
    valid_hcl_chrs(Tail);
valid_hcl_chrs([E|Tail]) when 
      E >= $a, E =< $f  ->
    valid_hcl_chrs(Tail).

is_valid_passport([],_,Failed) ->
    case lists:flatten(Failed) of
        Res when Res == [];
                 Res == "cid" ->
            valid;
        _ ->
            invalid
    end;



is_valid_passport([E|Tail], Map, Failed) ->
    is_valid_passport(Tail, Map, 
                      [
                       case maps:is_key(E,Map) of
                           true ->
                               [];
                           false ->
                               E
                       end|Failed]).

is_valid_passport_p1([],Map,Failed) ->
    case lists:flatten(Failed) of
        Res when Res == [];
                 Res == "cid" ->
            {valid, Map};
        _ ->
            invalid
    end;
is_valid_passport_p1([E|Tail], Map, Failed) ->
    is_valid_passport_p1(Tail, Map, 
                         [
                          case maps:is_key(E,Map) of
                              true ->
                                  [];
                              false ->
                                  E
                          end|Failed]).
parse_to_maps(Last) when is_binary(Last) ->
    Split = string:tokens(binary_to_list(Last), "\n: "),
    Rec = parse_to_tuple_list(Split),
    [maps:merge(maps:from_list(Rec), ?BLANK_MAP)];
parse_to_maps([E|Tail]) ->
    Split = string:tokens(binary_to_list(E), "\n: "),
    Rec = parse_to_tuple_list(Split),
    [maps:merge(maps:from_list(Rec), ?BLANK_MAP)|
     parse_to_maps(Tail)].



parse_to_tuple_list([]) ->
    [];
parse_to_tuple_list([A,B|Tail]) ->
    [{A,B}|parse_to_tuple_list(Tail)].

split_records(<<>>, Mem) ->
    Mem;
split_records(<<10,10, Rest/binary>>, Mem) ->
    [Mem| split_records(Rest, <<>>)];
split_records(<<E:1/binary, Rest/binary>>, Mem) ->
    split_records(Rest, <<Mem/binary, E:1/binary>>).







read_input() ->
    {ok, Bin} = file:read_file("priv/input.txt"), 
    Bin.
