#!/bin/bash

INPUT_DIR="$1"
OUT_FILE="$2"

OPUS_HOME="."
TEMP="${TEMP:-/tmp}"

printf "file\tscore\n" > "$OUT_FILE"

for IN_WAV in "$INPUT_DIR"/*.wav
do
    echo "Processing: $IN_WAV"

    BASE="$TEMP/`basename \"$IN_WAV\" .wav`"

    OUT_PCM="$BASE.pcm"
    # OUT_OPUS="$BASE.opus"
    OUT_OPUS=/dev/null
    OUT_LABELS="$BASE.labels"

    sox "$IN_WAV" -b 16 -c 1 -r 16k -t raw "$OUT_PCM" > /dev/null

    $OPUS_HOME/opus_demo \
        -e audio 16000 1 8000 -forcemono \
        "$OUT_PCM" "$OUT_OPUS" "$OUT_LABELS" > /dev/null 2>&1

    SCORE=`awk '{ sum += $2; ++count } END { printf("%.2f", sum/count) }' < "$OUT_LABELS"`

    printf "`basename "$IN_WAV"`\t$SCORE\n" >> "$OUT_FILE"

    rm "$OUT_PCM" "$OUT_LABELS"

done
