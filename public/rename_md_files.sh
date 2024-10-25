#!/bin/bash

# 1. 日付をファイルから取得して、ファイル名と共に保存
declare -A file_dates

for file in *.md; do
    # 正確な 'updated_at' 行を取得
    date=$(grep "^updated_at: " "$file" | sed -E "s/updated_at: '(.*)T.*'/\1/")
    
    if [ -n "$date" ]; then
        file_dates["$file"]="$date"
        echo "Found date $date in file $file"
    else
        echo "No date found in file $file"
    fi
done

# 2. 日付順にソートしてリネーム
count=1
for file in $(for key in "${!file_dates[@]}"; do echo "${file_dates[$key]} $key"; done | sort | awk '{print $2}'); do
    echo "Renaming $file to article$count.md"
    mv "$file" "article$count.md"
    count=$((count + 1))
done

echo "ファイルが順番にリネームされました。"
