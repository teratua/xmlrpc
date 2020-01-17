-module(test).

-compile(export_all).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

%% Test: Encoding and decoding

encode_decode_test_() ->
    encode_decode(payload_calls()++payload_responses()).

encode_decode([]) -> [];
encode_decode([Payload|Rest]) ->
    {ok, EncodedPayload} = xmlrpc_encode:payload(Payload),
    {ok, DecodedPayload} = xmlrpc_decode:payload(lists:flatten(EncodedPayload)),
    [?_assert(Payload =:= DecodedPayload) | encode_decode(Rest)].


payload_calls() ->
    [{call, "echo", []},
     {call, "echo", [true]},
     {call, "echo", [false]},
     {call, "echo", [12]},
     {call, "echo", [12.1]},
     {call, "echo", ["bar"]},
     {call, "echo", [{date, "19980717T14:08:55"}]},
     {call, "echo", [{base64, "eW91IGNhbid0IHJlYWQgdGhpcyE="}]},
     {call, "echo", [{array, [1, 5.8, "baz"]}]},
     {call, "echo", [{struct, [{yes, true}, {no,false}]}]},
     {call, "echo",
      [{array, [{array, [1, 5.8, "baz",
			 {array, [{date, "19980717T14:08:55"},
				  {base64, "eW91IGNhbid0IHJlYWQgdGhpcyE="}]},
			 {struct, [{yes, true}, {no, false}]}]},
		"slartibartfast"]}]}].

payload_responses() ->
    [{response, [true]},
     {response, [false]},
     {response, [12]},
     {response, [12.1]},
     {response, ["bar"]},
     {response, [{date, "19980717T14:08:55"}]},
     {response, [{base64, "eW91IGNhbid0IHJlYWQgdGhpcyE="}]},
     {response, [{array, [1, 5.8, "baz"]}]},
     {response, [{struct, [{yes, true}, {no,false}]}]},
     {response, 
      [{array, [{array, [1, 5.8, "baz",
			 {array, [{date, "19980717T14:08:55"},
				  {base64, "eW91IGNhbid0IHJlYWQgdGhpcyE="}]},
			 {struct, [{yes, true}, {no, false}]}]},
		"slartibartfast"]}]},
     {response, {fault, 42, "foo"}}].

-endif.
