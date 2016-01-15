-module(ring_test).

-export([
         start/9,
         start/12
        ]).

%%------------------------------------------------------------------------------
start(R1Size, R2Size, R3Size, R4Size, CycleCount, L1Pin, L2Pin, L3Pin, L4Pin) ->
    spawn(
      fun() ->
              start_test(R1Size, R2Size, R3Size, R4Size, CycleCount,
                         L1Pin, L2Pin, L3Pin, L4Pin)
      end).

start(R1Size, R1CycleCount, R2Size, R2CycleCount, R3Size, R3CycleCount,
      R4Size, R4CycleCount, L1Pid, L2Pin, L3Pin, L4Pin) ->
    spawn(
      fun() ->
              start_test(R1Size, R1CycleCount, R2Size, R2CycleCount,
                         R3Size, R3CycleCount, R4Size, R4CycleCount,
                         L1Pid, L2Pin, L3Pin, L4Pin)
      end).

%%------------------------------------------------------------------------------
start_test(R1Size, R2Size, R3Size, R4Size, CycleCount, L1Pin, L2Pin, L3Pin, L4Pin) ->
    start_test(R1Size, CycleCount, R2Size, CycleCount,
               R3Size, CycleCount, R4Size, CycleCount,
               L1Pin, L2Pin, L3Pin, L4Pin).

start_test(R1Size, R1CycleCount, R2Size, R2CycleCount,
           R3Size, R3CycleCount, R4Size, R4CycleCount,
           L1Pin, L2Pin, L3Pin, L4Pin) ->
    Led1 = led:start(L1Pin),
    Led2 = led:start(L2Pin),
    Led3 = led:start(L3Pin),
    Led4 = led:start(L4Pin),

    FirstRelay1 = ring:create(R1Size, R1CycleCount, Led1, self()),
    FirstRelay2 = ring:create(R2Size, R2CycleCount, Led2, self()),
    FirstRelay3 = ring:create(R3Size, R3CycleCount, Led3, self()),
    FirstRelay4 = ring:create(R4Size, R4CycleCount, Led4, self()),

    FirstRelay1 ! 0,
    FirstRelay2 ! 0,
    FirstRelay3 ! 0,
    FirstRelay4 ! 0,

    receive done -> ok end,
    receive done -> ok end,
    receive done -> ok end,
    receive done -> ok end,

    FirstRelay1 ! terminate,
    FirstRelay2 ! terminate,
    FirstRelay3 ! terminate,
    FirstRelay4 ! terminate,

    led:stop(Led1),
    led:stop(Led2),
    led:stop(Led3),
    led:stop(Led4).
