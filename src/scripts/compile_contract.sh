#!/usr/bin/env bash
set -o errexit

# set PATH
PATH="$PATH:/opt/eosio/bin"

if [ "$#" -lt 3 ]; then
  echo "usage: compile_contract.sh <filename> <outputPath> <contractName> [buildFlag ...]" >&2
  exit 2
fi

filename="$1"
outputPath="$2"
contractName="$3"
# Everything after the third argument is one build flag per argument. The caller
# splits them, so nothing here is re-interpreted by a shell: an unquoted "$4"
# used to let a flag from a committed .lamflags file run as a command.
shift 3

# Ensure the output directory exists
mkdir -p "project/$outputPath"

# Compile the smart contract to WASM and ABI using Antelope CDT.
# Add the contract's include directory so headers such as
# <contract.name/contract.name.hpp> can be resolved.
# https://github.com/AntelopeIO/cdt
cdt-cpp -abigen "$filename" -o "project/$outputPath/$contractName.wasm" -I "project/contracts/$contractName/include" --contract "$contractName" $4


