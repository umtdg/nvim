FROM umtdg/ubuntu:24.04

SHELL [ "/bin/bash", "-c" ]

USER ubuntu
WORKDIR /home/$USER

RUN mkdir -p $HOME/.config

# Install neovim and dependencies
RUN DEBIAN_FRONTEND=noninteractive sudo apt install -y --no-install-recommends \
	make gcc ripgrep unzip git xclip wget
RUN wget -q --show-progress https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
RUN sudo tar -C /opt -xzf nvim-linux64.tar.gz
RUN echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' | sudo tee -a $HOME/.bashrc
RUN rm -fv nvim-linux64.tar.gz

# Add config 
ADD --chown=$USER . $HOME/.config/nvim
