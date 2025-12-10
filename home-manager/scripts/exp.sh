#!/usr/bin/env bash

DIR=${1:-.}

nautilus "$DIR" &> /dev/null &
