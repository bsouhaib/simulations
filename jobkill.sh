#!/bin/bash

for id in $(seq 223258  1 223400) 
do
	scancel $id
done
