FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-color
RUN printf 'APT::Get::Assume-Yes "true";\nAPT::Install-Recommends "false";\nAPT::Get::Install-Suggests "false";\n' > /etc/apt/apt.conf.d/99defaults

COPY excludes /etc/dpkg/dpkg.cfg.d/excludes

RUN packages="curl ca-certificates libssl1.0.0 vim" && \
    apt-get update && \
    apt-get upgrade -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" && \
    apt-get install ${packages} && \
    apt-get remove vim-tiny && \
    curl -L https://iterm2.com/misc/install_shell_integration_and_utilities.sh | /bin/bash && \
    apt-get autoremove && \
    apt-get clean && \
    tar -czf /usr/share/copyrights.tar.gz /usr/share/common-licenses /usr/share/doc/*/copyright && \
    rm -rf \
        /usr/share/doc \
        /usr/share/man \
        /usr/share/info \
        /usr/share/locale \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/* \
        /var/log/* \
        /var/cache/debconf/* \
        /usr/share/common-licenses* \
        /etc/systemd \
        /lib/lsb \
        /lib/udev \
        /usr/lib/x86_64-linux-gnu/gconv/IBM* \
        /usr/lib/x86_64-linux-gnu/gconv/EBC* && \
    mkdir -p /usr/share/man/man1 /usr/share/man/man2 \
        /usr/share/man/man3 /usr/share/man/man4 \
        /usr/share/man/man5 /usr/share/man/man6 \
        /usr/share/man/man7 /usr/share/man/man8

CMD ["/sbin/my_init"]