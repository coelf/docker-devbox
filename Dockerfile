from base/archlinux 

RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman -Su --noconfirm 
RUN yes |  pacman -Syu

RUN     pacman -S  --noconfirm -y \
        base-devel \
        bash-completion \
        jre8-openjdk openjdk8-src \
        maven \
        git \
        colordiff \
        jq \
        wget \
        curl \
		sudo 
  
# yaourt for aur package
RUN echo "[archlinuxfr]" >> /etc/pacman.conf \
    && echo "SigLevel = Never" >> /etc/pacman.conf  \
    && echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf \
    && pacman -Suy --noconfirm -y yaourt

#add user with sudoer 
RUN useradd -m -s /bin/bash devuser && echo "devuser:devuser" | chpasswd && \
    mkdir -p /home/devuser && chown -R devuser:devuser /home/devuser \
    && echo exec startxfce4 > /home/devuser/.xinitrc && \
    echo "%devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# yaourt need to be launched with a non root user
USER devuser
RUN yaourt -S --noconfirm xrdp

USER root
RUN pacman -S --noconfirm systemd openssh && \
    systemctl enable xrdp.service && systemctl enable xrdp-sesman.service && \
    systemctl enable sshd.service && systemctl enable sshd.socket

#RUN pacman -S --noconfirm -y i3
RUN pacman -S --noconfirm -y xfce4

USER root
#RUN mkdir -p /home/devuser && echo exec i3 > /home/devuser/.xinitrc
RUN useradd -m -s /bin/bash vagrant && echo "vagrant:vagrant" | chpasswd && \
    mkdir -p /home/vagrant \
    && echo exec startxfce4 > /home/vagrant/.xinitrc \
    && chown -R vagrant:vagrant /home/vagrant && \
    echo "%devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER root
# add the vagrant insecure public key
RUN mkdir -p /home/vagrant/.ssh \
    && chmod 0700 /home/vagrant/.ssh \
    && wget --no-check-certificate \
      https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
      -O /home/vagrant/.ssh/authorized_keys \
    && chmod 0600 /home/vagrant/.ssh/authorized_keys \
&& chown -R vagrant /home/vagrant/.ssh

RUN  pacman -S --noconfirm -y \	
        kdiff3 \
        meld \
		firefox \
		eclipse-jee 

#i3 enhancement
#USER devuser
#WORKDIR /home/devuser
#RUN yaourt -S --noconfirm compton feh polybar-git rofi
#RUN git clone https://github.com/coelf/dotfiles.git 

CMD /usr/lib/systemd/systemd

EXPOSE 3389
EXPOSE 22
#EXPOSE 8080
#EXPOSE 1521