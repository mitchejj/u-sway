# Multi-stage build
ARG FEDORA_MAJOR_VERSION=38

## Build
FROM ghcr.io/mitchejj/sericea-base:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

# Add Tailscale
RUN wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale.repo

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    flatpak remote-delete fedora

#COPY etc /etc

RUN rpm-ostree override remove  \
      open-vm-tools-desktop open-vm-tools qemu-guest-agent spice-vdagent \
      spice-webdavd virtualbox-guest-additions && \
    rpm-ostree install neovim tmux tailscale \
      NetworkManager-tui nm-connection-editor-desktop wavemon \
      powerline-fonts fontawesome5-fonts-all google-android-emoji-fonts \
      google-noto-sans-fonts google-noto-serif-fonts \
      google-roboto-condensed-fonts google-roboto-fonts google-roboto-mono-fonts google-roboto-slab-fonts \
      mozilla-fira-mono-fonts mozilla-fira-sans-fonts \
      ibm-plex-fonts-all jetbrains-mono-fonts-all && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo && \
    rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit
