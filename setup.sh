#!/bin/bash

cd "${0%/*}"
npm install
read -n1 -r -p "Press any key to continue..." key