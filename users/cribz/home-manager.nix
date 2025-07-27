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

    pkgs._1password-cli
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
    pkgs.virtualenv
    pkgs.php83
    pkgs.php83Packages.composer

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
    (pkgs.writeShellScriptBin "tmux-sessionizer" (builtins.readFile ./tmux-sessionizer))
    (pkgs.writeShellScriptBin "sesh-picker" (builtins.readFile ./sesh-picker.sh))

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

    pkgs.zoxide
    pkgs.sesh

    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.zed-mono
    pkgs.ibm-plex

    # pkgs.lxappearance

    pkgs.nodePackages.pnpm

    inputs.zen-browser.packages."${pkgs.system}".default

    # pkgs.gtk3

    pkgs.yazi
    pkgs.unzip

    pkgs.openjdk

    pkgs.odin
    pkgs.clang-tools

    pkgs.ocaml
    pkgs.opam
    pkgs.dune_3

    pkgs.tree-sitter
    pkgs.sourcekit-lsp
    pkgs.swift
    pkgs.swiftpm
    pkgs.binutils
    # pkgs.libclang
    # pkgs.clang
    # (lib.hiPrio pkgs.dart)
  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    # LD_LIBRARY_PATH=${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXi}/lib:${pkgs.raylib}/lib:${pkgs.mesa}/lib:${pkgs.libglvnd}/lib:$LD_LIBRARY_PATH
    LIBRARY_PATH = "${pkgs.gcc.cc.lib}/lib:${pkgs.glibc}/lib";
    SOURCEKIT_LOGGING = "1";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  home.file.".gdbinit".source = ./gdbinit;
  home.file.".inputrc".source = ./inputrc;

  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.1.0";
    sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  };

  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3-new;
    "rofi/config.rasi".text = builtins.readFile ./rofi;
    "hypr/hyprland.conf".text = builtins.readFile ./hyprland;
    "hypr/hyprpaper.conf".text = builtins.readFile ./hyprpaper;
    "polybar".source = ./polybar;
    

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

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    image = /home/cribz/Wallpapers/gankutsuou.jpg;
    polarity = "dark";

    targets = {
      ghostty.enable = true;
      i3.enable = true;
      neovim.enable = false;
    };
    
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
    };
  };

  # stylix.enable = true;
  # #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  # stylix.image = /home/cribz/Wallpapers/wallhaven-e8z3w8.png;
  # stylix.polarity = "dark";

  # stylix.fonts = {
  #   monospace = {
  #     package = pkgs.ubuntu_font_family;
  #     name = "Ubuntu Mono";
  #   };
  #   sansSerif = {
  #     package = pkgs.ubuntu_font_family;
  #     name = "Ubuntu";
  #   };
  # };

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
      #plugins = [ "git" "z" ];
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
    };

    initContent = ''
      export PATH=$HOME/.cargo/bin:$PATH
      eval "$(zoxide init zsh)"
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

      set-option -g renumber-windows on
      set -g base-index 1
      setw -g pane-base-index 1

      # set -g @dracula-show-battery false
      # set -g @dracula-show-network false
      # set -g @dracula-show-weather false

      set -g @plugin 'vaaleyard/tmux-dotbar'
      set -g @tmux-dotbar-right true
      set -g @tmux-dotbar-bg "#282828"
      set -g @tmux-dotbar-fg "#7c6f64"
      set -g @tmux-dotbar-fg-current "#ebdbb2"
      set -g @tmux-dotbar-fg-session "#a89984"
      set -g @tmux-dotbar-fg-prefix "#d3869b"

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      set -s escape-time 0

      bind -r m resize-pane -Z

      #bind -n C-k send-keys "clear"\; send-keys "Enter"

      set -g mouse on

      set-window-option -g mode-keys vi

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection

      bind-key -r f run-shell "tmux neww "tmux-sessionizer""
      bind-key -r W run-shell "tmux-sessionizer /host/carchingtech/Work"
      bind-key -r C run-shell "tmux-sessionizer /host/carchingtech/ghq/github.com/carching-co"

      bind-key "T" run-shell "sesh-picker"

      run-shell ${sources.tmux-pain-control}/pain_control.tmux

      run '~/.tmux/plugins/tpm/tpm'
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
    # package = pkgs.neovim-unwrapped;
    # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    withPython3 = true;

    extraPackages = with pkgs; [
      lua-language-server
      pyright
      nodePackages.intelephense 
      zls
      jdt-language-server
      rust-analyzer
      nodePackages.typescript-language-server
      gopls
      # sourcekit-lsp
      # odin
      ols
      csharp-ls
    ];

    plugins = with pkgs; [
      #customVim.vim-copilot
      customVim.nvim-codecompanion
      customVim.nvim-config
      customVim.nvim-oil
      customVim.nvim-alpha
      # customVim.vim-cue
      # # customVim.vim-fish
      customVim.vim-fugitive
      customVim.nvim-spectre
      # customVim.vim-glsl
      # customVim.vim-pgsql
      # customVim.vim-tla
      # customVim.vim-zig
      # customVim.pigeon
      # customVim.AfterColors

      customVim.vim-nord
      customVim.nvim-rosepine
      customVim.nvim-gruvbox
      # customVim.nvim-cinnamon
      customVim.nvim-comment
      customVim.nvim-cmp
      customVim.nvim-luasnip
      customVim.nvim-cmp-nvim-lsp
      customVim.nvim-cmp-path
      customVim.nvim-friendly-snippets
      customVim.nvim-lspkind
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
      customVim.nvim-tmux-navigator
      customVim.nvim-trouble
      customVim.nvim-gitsigns
      customVim.nvim-fzf-lua
      customVim.nvim-octo
      customVim.nvim-nyoom
      customVim.nvim-spaceduck
      customVim.nvim-supermaven
      customVim.nvim-harpoon
      customVim.nvim-colorbuddy
      # customVim.nvim-flutter-tools
      # customVim.nvim-treesitter-playground
      # customVim.nvim-treesitter-textobjects

      # vimPlugins.vim-airline
      # vimPlugins.vim-airline-themes
      # vimPlugins.vim-eunuch
      # vimPlugins.vim-gitgutter
      #
      # vimPlugins.vim-markdown
      # vimPlugins.vim-nix
      # customVim.nvim-treesitter
      # vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-treesitter-textobjects
      (vimPlugins.nvim-treesitter.withPlugins (p: [
        p.php
        p.go
        p.odin
        p.lua
        p.c
        p.dart
        p.swift
      ]))
      # vimPlugins.nvim-treesitter.withAllGrammars
      # vimPlugins.typescript-vim
      # vimPlugins.nvim-treesitter-parsers.php
      # pkgs.tree-sitter-grammars.tree-sitter-php
      # vimPlugins.nvim-treesitter-parsers.odin
      # vimPlugins.nvim-treesitter-parsers.go
      # vimPlugins.nvim-treesitter-parsers.elixir

      # vimPlugins.nvim-ts-context-commentstring
      # vimPlugins.vim-commentary
      # customVim.nvim-mini
      # customVim.nvim-mini-comment
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
    # name = "Vanilla-DMZ";
    # package = pkgs.vanilla-dmz;
    # name = "Bibata-Modern-Ice";
    # package = pkgs.bibata-cursors;
    # name = "phinger-cursors-dark";
    # package = pkgs.phinger-cursors;
    name = "MacOS-Tahoe-Cursor";
    package = pkgs.runCommand "MacOS-Tahoe-Cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${/home/cribz/Downloads/MacOS-Tahoe-Cursor/MacOS-Tahoe-Cursor} $out/share/icons/MacOS-Tahoe-Cursor
    '';
    x11.enable = true;
    gtk.enable = true;
    size = 56;
  };

  # gtk = {
  #   enable = true;
  #
  #   theme = {
  #     name = "Adwaita-dark";
  #     package = pkgs.gnome.gnome-themes-extra;
  #   };
  #
  #   cursorTheme = {
  #     name = "Vanilla-DMZ";
  #     package = pkgs.vanilla-dmz;
  #     size = 128;
  #   };
  # };
}
