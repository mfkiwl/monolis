#!/bin/bash

./monolis_test

mpirun --oversubscribe --allow-run-as-root -np 2 ./monolis_test

cd input

./run.CI.sh
