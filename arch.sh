#!/usr/bin/env sh

# if kde
#sudo pacman -Syu spectacle xdg-desktop-portal-gtk flatpak partitionmanager okular geoclue elisa dragon filelight gwenview

# if runner
#sudo pacman -Syu flatpak wget --noconfirm

install_base_packages() {
    sudo pacman -Syu firefox ttf-dejavu docker docker-compose git go btop neovim reflector ttf-jetbrains-mono zsh pacman-contrib bat inter-font pkgstats fish ttf-roboto less --noconfirm
}

install_gnome_packages() {
    # if gnome
    sudo pacman -Syu ghostty papers nautilus-python --noconfirm
}

install_intellij() {
    sudo mkdir /opt/intellij
    sudo chown -R "$USER" /opt/intellij
}

configure_docker() {
    sudo usermod -aG docker "$USER" #mantain to remove another moment
}

install_flatpaks() {
    #flatpak install flathub com.spotify.Client flathub com.valvesoftware.Steam com.github.tchx84.Flatseal com.obsproject.Studio dev.vencord.Vesktop io.dbeaver.DBeaverCommunity org.kde.kdenlive org.libreoffice.LibreOffice -y
    flatpak install flathub com.valvesoftware.Steam -y
}

enable_services() {
    sudo systemctl enable docker
    sudo systemctl enable reflector.timer
    sudo systemctl enable fstrim.timer
    sudo systemctl enable paccache.timer
    sudo systemctl enable pkgstats.timer
}

configure_aur() {
    sudo pacman-key --init
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB

    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    printf "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n" | sudo tee -a /etc/pacman.conf

}

install_aur_packages() {
    sudo pacman -Syu visual-studio-code-bin --noconfirm
}

download_intellij() {
    wget -nv -O idea.tar.gz "https://download.jetbrains.com/idea/ideaIC-2024.3.5.tar.gz"
    tar -xzf idea.tar.gz
    mv idea-IC-243.26053.27/* /opt/intellij/
    rm -rf idea-IC-243.26053.27
}

configure_home() {
    cp .gitconfig ~/ #warning: where is my email?
    mkdir -p ~/.config/fontconfig
    cp ./fontconfig/fonts.conf ~/.config/fontconfig/
    cp .mise.toml ~/
}

configure_mise() {
    curl https://mise.run | sh
    echo '~/.local/bin/mise activate fish | source' >> ~/.config/fish/config.fish
}

configure_load_disk() {
    sudo cp 50-udisks.rules /etc/polkit-1/rules.d/
}


configure_home
download_intellij
configure_aur
install_aur_packages
enable_services
install_flatpaks

configure_load_disk
configure_mise

sudo pacman -R htop nano epiphany gnome-tour gnome-console --noconfirm
