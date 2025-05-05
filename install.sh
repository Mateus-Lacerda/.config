# This script is intended to be run on a fresh install of Arch Linux
# Update
sudo pacman -Syu --noconfirm

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

# Base stuff
sudo pacman -S --noconfirm git man mupdf neofetch wget curl \
    pavucontrol bluez blueman arandr kitty btop cmatrix

# Cool fonts
yay -S --noconfirm nerd-fonts-sf-mono
sudo pacman -S --noconfirm ttf-fira-code

# Install i3 stuff
sudo pacman -S i3blocks picom rofi dunst --noconfirm
yay -S --noconfirm i3lock-color

# Install neovim
sudo pacman -S --noconfirm neovim

# Neovim stuff
sudo pacman -S --noconfirm luarocks fd ripgrep xclip

# Install zsh
sudo pacman -S --noconfirm zsh
sudo chsh -s $(which zsh)

# Install ohmzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ohmyzsh plugins
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install tmux
sudo pacman -S --noconfirm tmux

# grub theme
git clone https://github.com/mino29/tokyo-night-grub.git
cd tokyo-night-grub
sudo cp -r tokyo-night /boot/grub/themes
echo 'Copy this: GRUB_THEME="/boot/grub/themes/tokyo-night/theme.txt" to /etc/default/grub, press enter to continue'; read
sudo nvim /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

mkdir Downloads
cd Downloads
# Get my dotfiles
git clone https://github.com/Mateus-Lacerda/.config.git
# Get my neovim config
git clone https://github.com/Mateus-Lacerda/neovim_config.git
# Get my zsh config
git clone https://github.com/Mateus-Lacerda/zshrc.git

sudo cp -rf ./.config/* ~/.config/
sudo mkdir -p ~/.config/nvim
sudo cp -rf ./neovim_config/* ~/.config/nvim/
sudo cp -rf ./zshrc/* ~/

# Rofi theme
mv ~/.config/rofi ~/.config/rofi.bak
git clone https://github.com/w8ste/Tokyonight-rofi-theme.git ~/.config/rofi
sudo mv ~/.config/rofi/tokyonight.rasi /usr/share/rofi/themes
sudo mv ~/.config/rofi/tokyonight_big1.rasi /usr/share/rofi/themes
sudo mv ~/.config/rofi/tokyonight_big2.rasi /usr/share/rofi/themes
rm ~/.config/rofi/README.md


echo "Press Enter to reboot"; read

# Reboot
sudo reboot
