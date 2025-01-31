{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    inputs.ghostty.packages.${pkgs.system}.default

    pkgs.asciinema
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.feh
    pkgs.python3
    pkgs.php

    pkgs.gopls
    pkgs.zigpkgs.default
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
      targets = [ "wasm32-unknown-unknown" ];
    })

    # Node is required for Copilot.vim
    pkgs.nodejs
  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.cachix
    pkgs.tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.chromium
    pkgs.firefox
    pkgs.rofi
    pkgs.valgrind
    pkgs.zathura
    pkgs.xfce.xfce4-terminal
    pkgs.pcmanfm

    # For raylib
    pkgs.pkg-config
    pkgs.gcc
    pkgs.libglvnd
    pkgs.mesa
    pkgs.xorg.libXi.dev        # X Input extension
    pkgs.xorg.libXcursor.dev   # X cursor management
    pkgs.xorg.libXrandr.dev    # RandR extension
    pkgs.xorg.libXinerama.dev  # Xinerama extensionpkgs.wayland
    pkgs.xorg.libX11.dev
    # pkgs.xorg.xorgproto
    pkgs.libGL.dev
    pkgs.libxkbcommon.dev
    pkgs.wayland
    pkgs.wayland-protocols
    pkgs.openssl.dev
  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  home.file.".gdbinit".source = ./gdbinit;
  home.file.".inputrc".source = ./inputrc;

  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3;
    "rofi/config.rasi".text = builtins.readFile ./rofi;

    # tree-sitter parsers
    # "nvim/parser/proto.so".source = "${pkgs.tree-sitter-proto}/parser";
    # "nvim/queries/proto/folds.scm".source =
    #   "${sources.tree-sitter-proto}/queries/folds.scm";
    # "nvim/queries/proto/highlights.scm".source =
    #   "${sources.tree-sitter-proto}/queries/highlights.scm";
    # "nvim/queries/proto/textobjects.scm".source =
    #   ./textobjects.scm;
  } // (if isDarwin then {
    # Rectangle.app. This has to be imported manually using the app.
    "rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;
  } else {}) // (if isLinux then {
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
  } else {});

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = !isDarwin;

  # programs.ghostty = {
  #   enable = true;
  # };

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "gi diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      open = "pcmanfm";
    };
  };

  # programs.direnv= {
  #   enable = true;
  #
  #   config = {
  #     whitelist = {
  #       prefix= [
  #         "$HOME/code/go/src/github.com/hashicorp"
  #         "$HOME/code/go/src/github.com/mitchellh"
  #       ];
  #
  #       exact = ["$HOME/.envrc"];
  #     };
  #   };
  # };

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" ([
  #     "source ${sources.theme-bobthefish}/functions/fish_prompt.fish"
  #     "source ${sources.theme-bobthefish}/functions/fish_right_prompt.fish"
  #     "source ${sources.theme-bobthefish}/functions/fish_title.fish"
  #     (builtins.readFile ./config.fish)
  #     "set -g SHELL ${pkgs.fish}/bin/fish"
  #   ]));
  #
  #   shellAliases = {
  #     ga = "git add";
  #     gc = "git commit";
  #     gco = "git checkout";
  #     gcp = "git cherry-pick";
  #     gdiff = "git diff";
  #     gl = "git prettylog";
  #     gp = "git push";
  #     gs = "git status";
  #     gt = "git tag";
  #   } // (if isLinux then {
  #     # Two decades of using a Mac has made this such a strong memory
  #     # that I'm just going to keep it consistent.
  #     pbcopy = "xclip";
  #     pbpaste = "xclip -o";
  #   } else {});
  #
  #   plugins = map (n: {
  #     name = n;
  #     src  = sources.${n};
  #   }) [
  #     "fish-fzf"
  #     "fish-foreign-env"
  #     "theme-bobthefish"
  #   ];
  # };

  programs.zsh = {
    enable = true;
    shellAliases = {
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      vim = "nvim";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      theme = "robbyrussell";
    };

    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
    };

    initExtra = ''
      export PATH=$HOME/.cargo/bin:$PATH
    '';
  };

  programs.git = {
    enable = true;
    userName = "Firdaus Yusof";
    userEmail = "firdausyusof06@gmail.com";
    aliases = {
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "firdausyusofs";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "code/go";
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "a";
    secureSocket = false;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      set -g @dracula-show-battery false
      set -g @dracula-show-network false
      set -g @dracula-show-weather false

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      bind -r m resize-pane -Z

      #bind -n C-k send-keys "clear"\; send-keys "Enter"

      set -g mouse on

      set-window-option -g mode-keys vi

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection

      run-shell ${sources.tmux-pain-control}/pain_control.tmux
      run-shell ${sources.tmux-dracula}/dracula.tmux
    '';
  };

  programs.alacritty = {
    enable = !isWSL;

    settings = {
      env.TERM = "xterm-256color";

      keyboard.bindings = [
        { key = "K"; mods = "Command"; chars = "ClearHistory"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "NumpadSubtract"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
    };
  };

  programs.kitty = {
    enable = !isWSL;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.i3status = {
    enable = isLinux && !isWSL;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    withPython3 = true;

    extraPackages = with pkgs; [
      lua-language-server
      pyright
      nodePackages.intelephense 
      zls
      rust-analyzer
      nodePackages.typescript-language-server
    ];

    plugins = with pkgs; [
      customVim.vim-copilot
      customVim.nvim-config
      customVim.nvim-oil
      customVim.nvim-alpha
      # customVim.vim-cue
      # # customVim.vim-fish
      customVim.vim-fugitive
      # customVim.vim-glsl
      # customVim.vim-pgsql
      # customVim.vim-tla
      # customVim.vim-zig
      # customVim.pigeon
      # customVim.AfterColors

      customVim.vim-nord
      customVim.nvim-rosepine
      # customVim.nvim-cinnamon
      # customVim.nvim-comment
      customVim.nvim-cmp
      customVim.nvim-cmp-nvim-lsp
      customVim.nvim-cmp-path
      customVim.nvim-friendly-snippets
      customVim.nvim-lspkind
      customVim.nvim-luasnip
      customVim.nvim-cmp-luasnip
      customVim.nvim-conform
      customVim.nvim-lspconfig
      # customVim.nvim-mason
      # customVim.nvim-mason-lspconfig
      customVim.nvim-schemastore

      customVim.nvim-plenary # required for telescope
      customVim.nvim-telescope
      customVim.nvim-telescope-fzf-native
      customVim.nvim-telescope-ui-select
      customVim.nvim-refactoring
      customVim.nvim-treesitter
      # customVim.nvim-treesitter-playground
      # customVim.nvim-treesitter-textobjects

      # vimPlugins.vim-airline
      # vimPlugins.vim-airline-themes
      # vimPlugins.vim-eunuch
      # vimPlugins.vim-gitgutter
      #
      # vimPlugins.vim-markdown
      # vimPlugins.vim-nix
      vimPlugins.typescript-vim
      vimPlugins.nvim-treesitter-parsers.php
      # vimPlugins.nvim-treesitter-parsers.elixir
    ] ++ (lib.optionals (!isWSL) [
      # This is causing a segfaulting while building our installer
      # for WSL so just disable it for now. This is a pretty
      # unimportant plugin anyway.
      # customVim.vim-devicons
    ]);

    extraConfig = (import ./vim-config.nix) { inherit sources; };
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentryPackage = pkgs.pinentry-tty;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    x11.enable = true;
    gtk.enable = true;
    size = 128;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 128;
    };
  };
}
