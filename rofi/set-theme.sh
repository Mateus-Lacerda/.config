#!/bin/bash

# Script para definir tema do rofi simplemenu
# Uso: ./set-theme.sh <nome-do-tema>

ROFI_DIR="$HOME/.config/rofi"
THEMES_DIR="$ROFI_DIR/themes"
CURRENT_SIMPLEMENU="$THEMES_DIR/simplemenu.rasi"
CURRENT_BASE_THEME="$THEMES_DIR/base-theme.rasi"

# Verifica se foi passado um parâmetro
if [ $# -eq 0 ]; then
    echo "Uso: $0 <nome-do-tema>"
    echo ""
    echo "Temas disponíveis:"
    ls "$THEMES_DIR"/simplemenu-*.rasi 2>/dev/null | sed 's|.*/simplemenu-||; s|\.rasi||' | sort
    exit 1
fi

THEME_NAME="$1"
SIMPLEMENU_THEME_FILE="$THEMES_DIR/simplemenu-$THEME_NAME.rasi"
BASE_THEME_FILE="$THEMES_DIR/$THEME_NAME.rasi"

# Verifica se os arquivos dos temas existem
if [ ! -f "$SIMPLEMENU_THEME_FILE" ]; then
    echo "Erro: Tema simplemenu '$THEME_NAME' não encontrado!"
    echo "Arquivo esperado: $SIMPLEMENU_THEME_FILE"
    echo ""
    echo "Temas disponíveis:"
    ls "$THEMES_DIR"/simplemenu-*.rasi 2>/dev/null | sed 's|.*/simplemenu-||; s|\.rasi||' | sort
    exit 1
fi

if [ ! -f "$BASE_THEME_FILE" ]; then
    echo "Erro: Tema base '$THEME_NAME' não encontrado!"
    echo "Arquivo esperado: $BASE_THEME_FILE"
    echo ""
    echo "Temas base disponíveis:"
    ls "$THEMES_DIR"/*.rasi 2>/dev/null | grep -v "simplemenu-" | grep -v "base-theme.rasi" | sed 's|.*/||; s|\.rasi||' | sort
    exit 1
fi

# Remove os links simbólicos atuais se existirem
if [ -L "$CURRENT_SIMPLEMENU" ]; then
    rm "$CURRENT_SIMPLEMENU"
    echo "Link simbólico simplemenu anterior removido."
elif [ -f "$CURRENT_SIMPLEMENU" ]; then
    echo "Aviso: $CURRENT_SIMPLEMENU existe como arquivo regular, não como link simbólico."
    echo "Removendo arquivo..."
    rm "$CURRENT_SIMPLEMENU"
fi

if [ -L "$CURRENT_BASE_THEME" ]; then
    rm "$CURRENT_BASE_THEME"
    echo "Link simbólico base-theme anterior removido."
elif [ -f "$CURRENT_BASE_THEME" ]; then
    echo "Aviso: $CURRENT_BASE_THEME existe como arquivo regular, não como link simbólico."
    echo "Removendo arquivo..."
    rm "$CURRENT_BASE_THEME"
fi

# Cria os novos links simbólicos
ln -s "simplemenu-$THEME_NAME.rasi" "$CURRENT_SIMPLEMENU"
ln -s "$THEME_NAME.rasi" "$CURRENT_BASE_THEME"

if [ $? -eq 0 ]; then
    echo "Tema '$THEME_NAME' definido com sucesso!"
    echo "Links simbólicos criados:"
    echo "  $CURRENT_SIMPLEMENU -> simplemenu-$THEME_NAME.rasi"
    echo "  $CURRENT_BASE_THEME -> $THEME_NAME.rasi"
else
    echo "Erro ao criar links simbólicos!"
    exit 1
fi
