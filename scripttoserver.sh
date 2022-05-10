#!/bin/bash
set -euo pipefail

rm -rf ./sandbox-runtime/api/script.sh && \
mkdir script.txt | \
gzip script.txt > \
./sandbox-runtime/api/script.txt.gz | \


zcat ./sandbox-runtime/api/script.txt.gz >> \
./sandbox-runtime/api/script.sh | \
chmod -w ./sandbox-runtime/api/script.sh | \
chmod +x ./sandbox-runtime/api/script.sh | \

zcat ./sandbox-runtime/api/script.txt.gz >> \
./sts-runtime/api/script.sh | \
chmod -w ./sts-runtime/api/script.sh | \
chmod +x ./sts-runtime/api/script.sh 
