#!/bin/bash
read -p "请输入要拉取的一言数量: " count
target=0
total=$(wc -l < ~/.hitokoto 2>/dev/null || echo 0)
existing_ids=$(cut -d'|' -f2 ~/.hitokoto 2>/dev/null)
while [ "$target" -lt "$count" ]; do
    response=$(curl -s 'https://v1.hitokoto.cn/?c=k')
    id=$(echo "$response" | jq -r '.id')
    hitokoto=$(echo "$response" | jq -r '.hitokoto')
    if echo "$existing_ids" | grep -qx "$id"; then
        continue
    fi
    echo "${hitokoto}|${id}" >> ~/.hitokoto
    existing_ids="${existing_ids}"$'\n'"${id}"
    target=$((target + 1))
    total=$((total + 1))
    echo "[$target/$count] 已拉取: ${hitokoto:0:30}..."
    sleep 0.5
done
echo "完成！共 ${count} 条，已保存到 ~/.hitokoto（共 ${total} 条）"
