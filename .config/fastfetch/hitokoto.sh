#!/bin/bash
raw=$(shuf -n1 ~/.hitokoto)
full_line=$(echo "$raw" | cut -d'|' -f1)
hitokoto_id=$(echo "$raw" | cut -d'|' -f2)
line="$full_line"
colors=$'\033[40m  \033[41m  \033[42m  \033[43m  \033[44m  \033[45m  \033[46m  \033[47m  \033[m\033[100m  \033[101m  \033[102m  \033[103m  \033[104m  \033[105m  \033[106m  \033[107m  \033[m'
w=104
max_len=$((w - 37))

line_width=$(printf '%s' "$line" | wc -L)
if [ "$line_width" -gt "$max_len" ]; then
    while [ "$(printf '%s' "$line" | wc -L)" -gt "$max_len" ]; do
        line="${line:0:${#line}-1}"
    done
    line="${line}..."
fi

url="https://hitokoto.cn?id=${hitokoto_id}"
display=$'\033]8;;'"${url}"$'\033\\'"${line}"$'\033]8;;\033\\'
pad=$((w - $(printf '%s' "$line" | wc -L) - 34))
printf $'\033[38;2;255;255;255m┌'; printf '─%.0s' $(seq 1 $w); printf $'┐\033[0m\n'
printf $'\033[38;2;255;255;255m│\033[0m %s%'"${pad}"'s' "$display" ""; printf "$colors"; printf $'\033[38;2;255;255;255m │\033[0m\n'
printf $'\033[38;2;255;255;255m└'; printf '─%.0s' $(seq 1 $w); printf $'┘\033[0m\n'
