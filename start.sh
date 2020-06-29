#!/bin/bash

cd "${0%/*}"
node ./public/app.js
read -n1 -r -p "Press any key to continue..." key