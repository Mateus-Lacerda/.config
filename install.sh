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
    pavucontrol bluez blueman arandr kitty

# Cool fonts
yay -S --noconfirm nerd-fonts-sf-mono
sudo pacman -S --noconfirm ttf-fira-code

# Install i3 stuff
sudo pacman -S i3blocks picom rofi dunst --noconfirm
yay -S --noconfirm i3lock-color

# Install neovim
sudo pacman -S --noconfirm neovim

# Neovim stuff
# Luarocks
sudo pacman -S --noconfirm luarocks
# fd
sudo pacman -S --noconfirm fd
# ripgrep
sudo pacman -S --noconfirm ripgrep
# xclip
sudo pacman -S --noconfirm xclip

# Install zsh
sudo pacman -S --noconfirm zsh
sudo chsh -s $(which zsh)

# Install ohmzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ohmyzsh plugins
# powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting
# zsh-autosuggestions
yay -S --noconfirm zsh-autosuggestions
# zsh-syntax-highlighting
yay -S --noconfirm zsh-syntax-highlighting
# powerlevel10k
yay -S --noconfirm zsh-theme-powerlevel10k

# Install tmux
sudo pacman -S --noconfirm tmux

# grub theme
git clone https://github.com/mino29/tokyo-night-grub.git
cd tokyo-night-grub
sudo cp -r themes/tokyo-night /boot/grub/themes
sudo sed -i 's/GRUB_THEME=.*/GRUB_THEME="/boot/grub/themes/tokyo-night/theme.txt"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Get my dotfiles
git clone git@github.com:Mateus-Lacerda/.config.git ./configs
# Get my neovim config
git clone git@github.com:Mateus-Lacerda/neovim_config ./configs/.config/nvim

sudo cp -r ./configs/.config ~/



echo "Press Enter to reboot"; read

# Reboot
sudo reboot

