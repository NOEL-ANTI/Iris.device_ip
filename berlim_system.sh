#!/bin/bash

clear
echo "=========================="
echo "   BERLIM ADB SYSTEM"
echo "=========================="
echo ""
echo "1 - Parear aparelho (ADB Wireless)"
echo "2 - Verificar Android ID"
echo "3 - Conectar manualmente"
echo "0 - Sair"
echo ""
read -p "Escolha: " op

if [ "$op" = "1" ]; then
    echo ""
    echo "[+] Ative no celular:"
    echo "    - Opções do desenvolvedor"
    echo "    - Depuração sem fio"
    echo ""
    read -p "IP:PORT (ex: 192.168.0.5:37123): " ipport
    read -p "Código de pareamento: " code

    adb pair $ipport $code

    echo ""
    echo "[+] Pareamento enviado."
    echo "Se deu certo, agora use opção 3 para conectar."

elif [ "$op" = "2" ]; then
    echo ""
    read -p "IP do dispositivo já pareado (ex: 192.168.0.5:5555): " ip

    adb connect $ip
    echo ""
    echo "[+] Android ID:"
    adb -s $ip shell settings get secure android_id

elif [ "$op" = "3" ]; then
    echo ""
    read -p "IP:PORT do dispositivo (ex: 192.168.0.5:5555): " ip

    adb connect $ip
    echo "[+] Conectado em $ip"

else
    echo ""
    echo "Saindo..."
fi
