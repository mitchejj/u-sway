# Multi-stage build
ARG FEDORA_MAJOR_VERSION=38

## Build
FROM ghcr.io/mitchejj/sericea-base:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

# Add Tailscale
RUN wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale.repo

COPY etc /etc

COPY ublue-firstboot /usr/bin

RUN rpm-ostree override remove firefox firefox-langpacks \
      open-vm-tools-desktop open-vm-tools qemu-guest-agent spice-vdagent \
      spice-webdavd virtualbox-guest-additions && \
    rpm-ostree install distrobox neovim tmux tailscale \
    NetworkManager-tui nm-connection-editor-desktop wavemon \
    powerline-fonts fontawesome5-fonts-all \
    just vte291-gtk4-devel && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo && \
    rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit
