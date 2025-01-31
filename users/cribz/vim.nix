{ inputs }:

self: super:

{
  # My vim config
  customVim = with self; {
    vim-copilot = vimUtils.buildVimPlugin {
      name = "vim-copilot";
      src = inputs.vim-copilot;
    };

    nvim-plenary = vimUtils.buildVimPlugin {
      name = "nvim-plenary";
      src = inputs.nvim-plenary;
      buildPhase = ":";
    };

    nvim-telescope = vimUtils.buildVimPlugin {
      name = "nvim-telescope";
      src = inputs.nvim-telescope;
      buildPhase = ":";
    };

    nvim-telescope-fzf-native = vimUtils.buildVimPlugin {
      name = "nvim-telescope-fzf-native";
      src = inputs.nvim-telescope-fzf-native;
      buildPhase = "make";
    };

    nvim-telescope-ui-select = vimUtils.buildVimPlugin {
      name = "nvim-telescope-ui-select";
      src = inputs.nvim-telescope-ui-select;
    };

    nvim-refactoring = vimUtils.buildVimPlugin {
      name = "nvim-refactoring";
      src = inputs.nvim-refactoring;
    };

    nvim-lspconfig = vimUtils.buildVimPlugin {
      name = "nvim-lspconfig";
      src = inputs.nvim-lspconfig;
      buildPhase = ":";
    };

    vim-fugitive = vimUtils.buildVimPlugin {
      name = "vim-fugitive";
      src = inputs.vim-fugitive;
    };

    # nvim-mason = vimUtils.buildVimPlugin {
    #   name = "nvim-mason";
    #   src = inputs.nvim-mason;
    # };
    #
    # nvim-mason-lspconfig = vimUtils.buildVimPlugin {
    #   name = "nvim-mason-lspconfig";
    #   src = inputs.nvim-mason-lspconfig;
    # };

    nvim-config = vimUtils.buildVimPlugin {
      name = "nvim-config";
      src = inputs.nvim-config;
    };

    nvim-oil = vimUtils.buildVimPlugin {
      name = "nvim-oil";
      src = inputs.nvim-oil;
    };

    nvim-schemastore = vimUtils.buildVimPlugin {
      name = "nvim-schemastore";
      src = inputs.nvim-schemastore;
    };

    nvim-cmp = vimUtils.buildVimPlugin {
      name = "nvim-cmp";
      src = inputs.nvim-cmp;
    };

    nvim-cmp-nvim-lsp = vimUtils.buildVimPlugin {
      name = "nvim-cmp-nvim-lsp";
      src = inputs.nvim-cmp-nvim-lsp;
    };

    nvim-cmp-path = vimUtils.buildVimPlugin {
      name = "nvim-cmp-path";
      src = inputs.nvim-cmp-path;
    };

    nvim-friendly-snippets = vimUtils.buildVimPlugin {
      name = "nvim-friendly-snippets";
      src = inputs.nvim-friendly-snippets;
    };

    nvim-lspkind = vimUtils.buildVimPlugin {
      name = "nvim-lspkind";
      src = inputs.nvim-lspkind;
    };

    nvim-luasnip = vimUtils.buildVimPlugin {
      name = "nvim-luasnip";
      src = inputs.nvim-luasnip;
    };

    nvim-cmp-luasnip = vimUtils.buildVimPlugin {
      name = "nvim-cmp-luasnip";
      src = inputs.nvim-cmp-luasnip;
    };

    nvim-conform = vimUtils.buildVimPlugin {
      name = "nvim-conform";
      src = inputs.nvim-conform;
    };

    nvim-alpha = vimUtils.buildVimPlugin {
      name = "nvim-alpha";
      src = inputs.nvim-alpha;
    };

    nvim-treesitter = vimUtils.buildVimPlugin {
      name = "nvim-treesitter";
      src = inputs.nvim-treesitter;
    };

    dracula = vimUtils.buildVimPlugin {
      name = "dracula";
      src = inputs.vim-dracula;
    };

    vim-nord = vimUtils.buildVimPlugin {
      name = "vim-nord";
      src = inputs.vim-nord;
    };

    nvim-rosepine = vimUtils.buildVimPlugin {
      name = "nvim-rosepine";
      src = inputs.nvim-rosepine;
    };
    #
    # vim-cue = vimUtils.buildVimPlugin {
    #   name = "vim-cue";
    #   src = sources.vim-cue;
    # };
    #
    # vim-fish = vimUtils.buildVimPlugin {
    #   name = "vim-fish";
    #   src = sources.vim-fish;
    # };
    #
    # vim-fugitive = vimUtils.buildVimPlugin {
    #   name = "vim-fugitive";
    #   src = sources.vim-fugitive;
    # };
    #
    # vim-glsl = vimUtils.buildVimPlugin {
    #   name = "vim-glsl";
    #   src = sources.vim-glsl;
    # };
    #
    # vim-misc = vimUtils.buildVimPlugin {
    #   name = "vim-misc";
    #   src = sources.vim-misc;
    # };
    #
    # vim-pgsql = vimUtils.buildVimPlugin {
    #   name = "vim-pgsql";
    #   src = sources.vim-pgsql;
    # };
    #
    # vim-tla = vimUtils.buildVimPlugin {
    #   name = "tla.vim";
    #   src = sources.vim-tla;
    # };
    #
    # vim-zig = vimUtils.buildVimPlugin {
    #   name = "zig.vim";
    #   src = sources.vim-zig;
    # };
    #
    
    # pigeon = vimUtils.buildVimPlugin {
    #   name = "pigeon.vim";
    #   src = sources.vim-pigeon;
    # };
    #
    # AfterColors = vimUtils.buildVimPlugin {
    #   name = "AfterColors";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "vim-scripts";
    #     repo = "AfterColors.vim";
    #     rev = "9936c26afbc35e6f92275e3f314a735b54ba1aaf";
    #     sha256 = "0j76g83zlxyikc41gn1gaj7pszr37m7xzl8i9wkfk6ylhcmjp2xi";
    #   };
    # };
    #
    # vim-devicons = vimUtils.buildVimPlugin {
    #   name = "vim-devicons";
    #   src = sources.vim-devicons;
    # };
    #
    #
    # nvim-cinnamon = vimUtils.buildVimPlugin {
    #   name = "nvim-cinnamon";
    #   src = inputs.nvim-cinnamon;
    # };
    #
    # nvim-comment = vimUtils.buildVimPlugin {
    #   name = "nvim-comment";
    #   src = sources.nvim-comment;
    #   buildPhase = ":";
    # };
    #
    
    # nvim-magma = vimUtils.buildVimPlugin {
    #   name = "nvim-magma";
    #   src = sources.nvim-magma;
    # };
    #
    #
    #
    # nvim-treesitter-playground = vimUtils.buildVimPlugin {
    #   name = "nvim-treesitter-playground";
    #   src = sources.nvim-treesitter-playground;
    # };
    #
    #
    # nvim-lspinstall = vimUtils.buildVimPlugin {
    #   name = "nvim-lspinstall";
    #   src = sources.nvim-lspinstall;
    # };
    #
    # nvim-treesitter-textobjects = vimUtils.buildVimPlugin {
    #   name = "nvim-treesitter-textobjects";
    #   src = sources.nvim-treesitter-textobjects;
    # };
  };

  # tree-sitter-php = self.callPackage
  #   (inputs.nixpkgs + "/pkgs/development/tools/parsing/tree-sitter/grammar.nix") { } {
  #   language = "php";
  #   version  = "0.23.11";
  #   source   = inputs.tree-sitter-php;
  # };

  # tree-sitter-proto = self.callPackage
  #   (sources.nixpkgs + /pkgs/development/tools/parsing/tree-sitter/grammar.nix) { } {
  #   language = "proto";
  #   version  = "0.1.0";
  #   source   = sources.tree-sitter-proto;
  # };
  #
  # tree-sitter-hcl = self.callPackage
  #   (sources.nixpkgs + /pkgs/development/tools/parsing/tree-sitter/grammar.nix) { } {
  #   language = "hcl";
  #   version  = "0.1.0";
  #   source   = sources.tree-sitter-hcl;
  # };
}
