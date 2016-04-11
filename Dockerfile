FROM quay.io/nuxeo/base-archlinux

MAINTAINER Nuxeo <contact@nuxeo.com>

RUN groupadd -g 1005 hudson && useradd -u 1005 -d /home/hudson -m -g 1005 hudson

RUN pacman-key --init && \
    pacman -Sy --noconfirm --needed --noprogressbar archlinux-keyring && \
    pacman -Syu --noconfirm --needed --noprogressbar base-devel git boost sudo pkgbuild-introspection && \
    pacman-db-upgrade

RUN echo 'hudson ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/hudson && \
    chmod 0440 /etc/sudoers.d/hudson

RUN cd /tmp && curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz && \
    curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz && \
    sudo -u hudson tar -xvzf package-query.tar.gz && \
    sudo -u hudson tar -xvzf yaourt.tar.gz && \
    cd package-query && sudo -u hudson makepkg -si --noconfirm && cd - && \
    cd yaourt && sudo -u hudson makepkg -si --noconfirm \

RUN rm -rf /var/cache/pacman/pkg
