#!/bin/bash

FILE="device.txt"

clear

echo "=========================="
echo "   BERLIM ADB SYSTEM V2"
echo "=========================="
echo ""

echo "1 - Parear aparelho"
echo "2 - Conectar dispositivo"
echo "3 - Verificar Android ID"
echo "4 - Mostrar dispositivo salvo"
echo "5 - Limpar dispositivo salvo"
echo "0 - Sair"
echo ""

read -p "Escolha: " op

# =========================

if [ "$op" = "1" ]; then
    echo ""
    echo "[+] Ative no celular:"
    echo "    - Opções do desenvolvedor"
    echo "    - Depuração sem fio (Wireless debugging)"
    echo ""

    read -p "IP:PORT de pareamento: " ipport
    read -p "Código: " code

    adb pair $ipport $code

    echo ""
    echo "[+] Agora conecte usando a opção 2"

# =========================

elif [ "$op" = "2" ]; then
    echo ""
    read -p "IP:PORT (ex: 192.168.0.5:5555): " ip

    adb connect $ip

    if [ $? -eq 0 ]; then
        echo $ip > $FILE
        echo "[+] Dispositivo salvo!"
    else
        echo "[!] Falha ao conectar"
    fi

# =========================

elif [ "$op" = "3" ]; then
    echo ""

    if [ ! -f "$FILE" ]; then
        echo "[!] Nenhum dispositivo salvo"
        exit
    fi

    ip=$(cat $FILE)

    adb connect $ip > /dev/null

    echo "[+] Pegando Android ID..."

    id=$(adb -s $ip shell settings get secure android_id 2>/dev/null)

    if [ -z "$id" ]; then
        echo "[!] Método padrão falhou, tentando alternativa..."

        id=$(adb -s $ip shell content query --uri content://settings/secure --where "name='android_id'" 2>/dev/null | grep value | cut -d= -f2)
    fi

    if [ -z "$id" ]; then
        echo "[!] Não foi possível obter o Android ID"
    else
        echo "[+] Android ID: $id"
    fi

# =========================

elif [ "$op" = "4" ]; then
    echo ""

    if [ -f "$FILE" ]; then
        echo "[+] Dispositivo salvo:"
        cat $FILE
    else
        echo "[!] Nenhum dispositivo salvo"
    fi

# =========================

elif [ "$op" = "5" ]; then
    rm -f $FILE
    echo "[+] Dispositivo removido"

# =========================

else
    echo "Saindo..."
fi
