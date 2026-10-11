#!/bin/bash

read -p "Введите адрес для ping: " HOST

FAILED=0

echo "Начинаем проверку $HOST..."
echo "Для остановки нажмите Ctrl+C"
echo

while true
do
    RESULT=$(ping -c 1 -W 1 "$HOST" 2>/dev/null)

    if [ $? -eq 0 ]; then

        TIME=$(echo "$RESULT" | grep -oE 'time=[0-9.]+ ms' | head -1 | cut -d= -f2 | cut -d' ' -f1)

        FAILED=0

        echo "[$(date '+%H:%M:%S')] $HOST — ping: ${TIME} ms"

        if (( $(echo "$TIME > 100" | bc -l) )); then
            echo "ВНИМАНИЕ: время ping превышает 100 мс!"
        fi

    else
        FAILED=$((FAILED + 1))

        echo "[$(date '+%H:%M:%S')] Не удалось выполнить ping. Попытка: $FAILED"

        if [ "$FAILED" -ge 3 ]; then
            echo "ВНИМАНИЕ: ping не выполнен 3 раза подряд!"
            FAILED=0
        fi
    fi

    sleep 1
done