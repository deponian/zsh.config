Automatic installation
------------

  Use ``install.sh`` script from the root of the repository


Manual installation
------------

  1. Launch Zsh:

     ```console
     zsh
     ```

  2. Clone the repository:

     ```console
     git clone --recursive https://github.com/deponian/zsh.config.git "${ZDOTDIR:-$HOME}/.zim"
     ```

  3. Create a new Zsh configuration by copying the Zsh configuration files provided:

     ```sh
     setopt EXTENDED_GLOB
     for rcfile in "${ZDOTDIR:-$HOME}"/.zim/runcoms/*; do
       ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
     done
     ```

  4. Set Zsh as your default shell:

     ```console
     chsh -s /bin/zsh
     ```

  5. Open a new Zsh terminal window or tab.

