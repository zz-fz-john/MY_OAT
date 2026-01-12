#!/bin/bash
cd oat-evaluation/"$1"
make test-combo
make opt-combo
make bin
make scp-"$1"