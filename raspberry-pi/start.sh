#!/bin/bash
erl +P 4000000 -pa ebin/ -eval "ring_test:start(1000, 100, 10000, 100, 25000, 100, 100000, 100, 4, 17, 27, 22)"
