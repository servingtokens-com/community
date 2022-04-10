#!/bin/bash

# bash embed.sh TOKEN_IMAGE.jpg Password123bash embed.sh
steghide embed -ef "./test.txt" -cf "${1}" -p "${2}"
