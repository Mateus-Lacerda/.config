#!/bin/bash

# Script de pós-instalação para Arch Linux
# Configura i3, neovim, zsh, temas e dotfiles personalizados
# Execute como usuário normal, com sudo apenas quando necessário

# Arquivo de log
LOG_FILE="$HOME/post_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Cores para mensagens
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Função para exibir mensagens
msg() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Função para exibir erros e sair
error() {
    echo -e "${RED}[!] Erro: $1${NC}" >&2
    exit 1
}

# Verifica se o comando anterior foi bem-sucedido
check_error() {
    if [ $? -ne 0 ]; then
        error "$1"
    fi
}

# Verifica se o sistema está online
check_internet() {
    msg "Verificando conexão com a internet..."
    ping -c 1 archlinux.org > /dev/null 2>&1 || error "Sem conexão com a internet"
}

# Função para instalar pacotes com pacman
install_pacman() {
    msg "Instalando pacotes: $@"
    sudo pacman -S --needed "$@"
    check_error "Falha ao instalar pacotes com pacman"
}

# Função para instalar pacotes com yay
install_yay() {
    msg "Instalando pacotes AUR: $@"
    yay -S --needed "$@"
    check_error "Falha ao instalar pacotes com yay"
}

# Função para fazer backup de diretórios
backup_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        msg "Fazendo backup de $dir para $dir.bak_$(date +%F_%H-%M-%S)"
        mv "$dir" "$dir.bak_$(date +%F_%H-%M-%S)"
    fi
}

# Verifica pré-requisitos
msg "Verificando se o sistema é Arch Linux..."
[ -f /etc/arch-release ] || error "Este script deve ser executado no Arch Linux"
check_internet

# Atualiza o sistema
msg "Atualizando o sistema..."
sudo pacman -Syu
check_error "Falha ao atualizar o sistema"

# Instala yay
if ! command -v yay &> /dev/null; then
    msg "Instalando yay..."
    install_pacman base-devel git
    git clone https://aur.archlinux.org/yay.git || error "Falha ao clonar yay"
    cd yay
    makepkg -si
    check_error "Falha ao instalar yay"
    cd ..
    [ -d yay ] && rm -rf yay
fi

# Instala pacotes base
install_pacman base-devel git man mupdf neofetch wget curl \
    pavucontrol bluez blueman arandr kitty btop cmatrix

# Instala fontes
install_pacman ttf-fira-code
install_yay nerd-fonts-sf-mono

# Instala pacotes do i3
install_pacman i3blocks picom rofi dunst
install_yay i3lock-color

# Instala neovim e dependências
install_pacman neovim luarocks fd ripgrep xclip

# Instala e configura zsh
install_pacman zsh
if [ "$(basename $SHELL)" != "zsh" ]; then
    msg "Configurando zsh como shell padrão..."
    sudo chsh -s $(which zsh) $USER
    check_error "Falha ao configurar zsh"
fi

# Instala oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    msg "Instalando oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    check_error "Falha ao instalar oh-my-zsh"
fi

# Instala plugins do oh-my-zsh
msg "Instalando plugins do oh-my-zsh..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || error "Falha ao clonar zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git || error "Falha ao clonar zsh-syntax-highlighting"
sudo mv zsh-syntax-highlighting /usr/share/ || error "Falha ao mover zsh-syntax-highlighting"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || error "Falha ao clonar powerlevel10k"

# Instala tmux
install_pacman tmux

# Configura tema do GRUB
msg "Configurando tema Tokyo Night para o GRUB..."
git clone https://github.com/mino29/tokyo-night-grub.git || error "Falha ao clonar tema do GRUB"
cd tokyo-night-grub
sudo cp -r tokyo-night /boot/grub/themes || error "Falha ao copiar tema do GRUB"
cd ..
[ -d tokyo-night-grub ] && rm -rf tokyo-night-grub
msg "Adicionando tema ao /etc/default/grub..."
sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub
echo 'GRUB_THEME="/boot/grub/themes/tokyo-night/theme.txt"' | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg || error "Falha ao atualizar configuração do GRUB"

# Aplica dotfiles
msg "Aplicando dotfiles..."
git clone https://github.com/Mateus-Lacerda/.config.git || error "Falha ao clonar dotfiles"
backup_dir ~/.config
cp -rf .config/* ~/.config/ || error "Falha ao copiar dotfiles"
[ -d .config ] && rm -rf .config

# Configura neovim
msg "Aplicando configuração do neovim..."
git clone https://github.com/Mateus-Lacerda/neovim_config.git || error "Falha ao clonar configuração do neovim"
backup_dir ~/.config/nvim
mv neovim_config ~/.config/nvim || error "Falha ao mover configuração do neovim"

# Configura zsh
msg "Aplicando configuração do zsh..."
git clone https://github.com/Mateus-Lacerda/zshrc.git || error "Falha ao clonar configuração do zsh"
backup_dir ~/.zshrc
mv zshrc/* ~ || error "Falha ao mover configuração do zsh"
[ -d zshrc ] && rm -rf zshrc

# Configura tema do rofi
msg "Aplicando tema Tokyo Night para o rofi..."
backup_dir ~/.config/rofi
git clone https://github.com/w8ste/Tokyonight-rofi-theme.git ~/.config/rofi || error "Falha ao clonar tema do rofi"
sudo mv ~/.config/rofi/tokyonight.rasi /usr/share/rofi/themes || error "Falha ao mover tokyonight.rasi"
sudo mv ~/.config/rofi/tokyonight_big1.rasi /usr/share/rofi/themes || error "Falha ao mover tokyonight_big1.rasi"
sudo mv ~/.config/rofi/tokyonight_big2.rasi /usr/share/rofi/themes || error "Falha ao mover tokyonight_big2.rasi"
[ -f ~/.config/rofi/README.md ] && rm ~/.config/rofi/README.md

# Finalização
msg "Instalação concluída! Log salvo em $LOG_FILE"
read -p "Deseja reiniciar agora? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    msg "Reiniciando o sistema..."
    reboot
else
    msg "Você pode reiniciar manualmente com 'reboot' quando desejar."
fi
