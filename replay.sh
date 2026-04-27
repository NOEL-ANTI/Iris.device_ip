set +e

echo "REMOVENDO SHADERS..."

SHADER_DIR="/sdcard/android/data/com.dts.freefireth/files/contentcache/optional/android/gameassetbundles"

SHADER_FILE=$(ls -t "$SHADER_DIR"/shaders* 2>/dev/null | head -n 1)

if [ -n "$SHADER_FILE" ] && [ -f "$SHADER_FILE" ]; then
  rm "$SHADER_FILE"
  echo "SHADER REMOVIDO: $SHADER_FILE"
else
  echo "NENHUM SHADER ENCONTRADO"
fi

set +e

echo "INICIANDO REPASSADOR..."

SRC_DIR="/sdcard/Android/data/com.dts.freefiremax/files/MReplays"
DST_DIR="/sdcard/Android/data/com.dts.freefireth/files/MReplays"
MARKER="$DST_DIR/.transfer_interna"

# checks
if [ ! -d "$SRC_DIR" ]; then
  echo "ERRO: origem nao existe"
  exit 1
fi

mkdir -p "$DST_DIR" 2>/dev/null

if [ -f "$MARKER" ]; then
  echo "JA EM EXECUCAO"
  exit 1
fi

touch "$MARKER"

# pegar arquivos
RECENT_BIN=$(ls -t "$SRC_DIR"/*.bin 2>/dev/null | head -n 1)
RECENT_JSON=$(ls -t "$SRC_DIR"/*.json 2>/dev/null | head -n 1)

echo "BIN: $RECENT_BIN"
echo "JSON: $RECENT_JSON"

if [ -z "$RECENT_BIN" ] && [ -z "$RECENT_JSON" ]; then
  echo "NENHUM REPLAY"
  rm -f "$MARKER"
  exit 1
fi

TRANSFER_OK=0

# copiar BIN
if [ -n "$RECENT_BIN" ] && [ -f "$RECENT_BIN" ]; then
  BASENAME_BIN=${RECENT_BIN##*/}

  cp "$RECENT_BIN" "$DST_DIR/$BASENAME_BIN" 2>/dev/null

  if [ -f "$DST_DIR/$BASENAME_BIN" ]; then
    chmod 644 "$DST_DIR/$BASENAME_BIN" 2>/dev/null
    touch -r "$RECENT_BIN" "$DST_DIR/$BASENAME_BIN" 2>/dev/null
    TRANSFER_OK=1
    echo "BIN OK"
  fi
fi

# copiar JSON
if [ -n "$RECENT_JSON" ] && [ -f "$RECENT_JSON" ]; then
  BASENAME_JSON=${RECENT_JSON##*/}

  cp "$RECENT_JSON" "$DST_DIR/$BASENAME_JSON" 2>/dev/null

  if [ -f "$DST_DIR/$BASENAME_JSON" ]; then
    chmod 644 "$DST_DIR/$BASENAME_JSON" 2>/dev/null
    touch -r "$RECENT_JSON" "$DST_DIR/$BASENAME_JSON" 2>/dev/null

    sed -i 's/"[Vv]ersion":"[^"]*"/"Version":"1.123.1"/' "$DST_DIR/$BASENAME_JSON" 2>/dev/null

    TRANSFER_OK=1
    echo "JSON OK"
  fi
fi

# resultado
if [ "$TRANSFER_OK" -eq 1 ]; then
  echo "REPLAY OK"
else
  echo "FALHOU"
fi

rm -f "$MARKER"