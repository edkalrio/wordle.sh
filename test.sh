#!/usr/bin/env bash

mapfile candidate -t < <(echo "654321" | grep -o . )
candidate_char="${candidate[7]}"
echo "${candidate_char}"