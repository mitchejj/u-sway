# Multi-stage build
ARG FEDORA_MAJOR_VERSION=38

## Build
#FROM ghcr.io/mitchejj/sericea-base:${FEDORA_MAJOR_VERSION}
FROM ghcr.io/ublue-os/sericea-main:38
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

RUN rpm-ostree override remove  \
      open-vm-tools-desktop open-vm-tools qemu-guest-agent spice-vdagent \
      spice-webdavd virtualbox-guest-additions \
      firefox firefox-langpacks && \
    rpm-ostree install neovim tmux tailscale power-profiles-daemon \
      vifm ldns-utils ncdu tumbler \
      NetworkManager-tui nm-connection-editor-desktop wavemon \
      powerline-fonts fontawesome5-fonts-all google-android-emoji-fonts \
      google-noto-sans-fonts google-noto-serif-fonts \
      google-roboto* \
      mozilla-fira-* fira-code-fonts \
      ibm-plex-fonts-all jetbrains-mono-fonts-all && \
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    rm -rf \
        /etc/yum.repos.d/tailscale.repo \
        /tmp/* \
        /var/* && \
    ostree container commit
