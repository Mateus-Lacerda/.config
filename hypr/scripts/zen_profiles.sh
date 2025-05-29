#!/bin/bash

# Caminho do arquivo de configuração
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Verificar se o arquivo existe
if [[ ! -f "$HYPR_CONF" ]]; then
    echo "Erro: Arquivo $HYPR_CONF não encontrado." >&2
    exit 1
fi

output="Perfis com Atalhos:\n"
while IFS= read -r line; do
    # Extrair a tecla (campo após "bind = ,")
    key=$(echo "$line" | awk -F ', ' '{print $2}')
    # Extrair o perfil (após "-P ")
    profile=$(echo "$line" | awk -F '-P ' '{print $2}' | tr -d '"')
    # Adicionar à saída com ícone e formatação
    output+="$key: $profile\n"
done <<< "$(grep "zen-browser -P" "$HYPR_CONF")"

echo -e "$output" > /tmp/profiles_output.txt

notify-send -a "Zen Profiles" -t 5000 -u normal "Perfis com Atalhos" "$output"
