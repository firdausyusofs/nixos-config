{
  description = "NixOS systems and tools by mitchellh";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # snapd
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # I think technically you're not supposed to override the nixpkgs
    # used by neovim but recently I had failures if I didn't pin to my
    # own. We can always try to remove that anytime.
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";

      inputs.neovim-flake.url = "github:neovim/neovim/v0.10.4?dir=contrib";

      # Only need unstable until the lpeg fix hits mainline, probably
      # not very long... can safely switch back for 23.11.
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";

      # inputs.nixpkgs-stable.follows = "nixpkgs";
      # inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other packages
    zig.url = "github:mitchellh/zig-overlay";
    rust.url = "github:oxalica/rust-overlay";

    # Non-flakes
    nvim-codecompanion.url = "github:olimorris/codecompanion.nvim";
    nvim-codecompanion.flake = false;
    nvim-cinnamon.url = "github:declancm/cinnamon.nvim";
    nvim-cinnamon.flake = false;
    nvim-conform.url = "github:stevearc/conform.nvim/v5.2.1";
    nvim-conform.flake = false;
    nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter";
    nvim-treesitter.flake = false;
    vim-copilot.url = "github:github/copilot.vim/v1.32.0";
    vim-copilot.flake = false;
    nvim-plenary.url = "github:nvim-lua/plenary.nvim/v0.1.4";
    nvim-plenary.flake = false;
    nvim-telescope.url = "github:nvim-telescope/telescope.nvim/0.1.8";
    nvim-telescope.flake = false;
    nvim-telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    nvim-telescope-ui-select = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    nvim-refactoring = {
      url = "github:ThePrimeagen/refactoring.nvim";
      flake = false;
    };
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig/v2.1.0";
    nvim-lspconfig.flake = false;
    nvim-config.url = "github:firdausyusofs/nvim-config";
    nvim-config.flake = false;
    nvim-oil.url = "github:stevearc/oil.nvim/v2.14.0";
    nvim-oil.flake = false;
    # nvim-mason.url = "github:williamboman/mason.nvim/v1.10.0";
    # nvim-mason.flake = false;
    # nvim-mason-lspconfig.url = "github:williamboman/mason-lspconfig.nvim/v1.31.0";
    # nvim-mason-lspconfig.flake = false;
    nvim-schemastore.url = "github:b0o/SchemaStore.nvim";
    nvim-schemastore.flake = false;
    nvim-cmp.url = "github:hrsh7th/nvim-cmp/b555203";
    nvim-cmp.flake = false;
    nvim-cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    nvim-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    nvim-friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
    nvim-lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    nvim-luasnip = {
      url = "github:L3MON4D3/LuaSnip/v2.3.0";
      flake = false;
    };
    nvim-cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    nvim-alpha = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };
    vim-dracula = {
      url = "github:dracula/vim/v2.0.0";
      flake = false;
    };
    vim-nord = {
      url = "github:crispgm/nord-vim";
      flake = false;
    };
    vim-fugitive = {
        url = "github:tpope/vim-fugitive/v3.7";
        flake = false;
    };
    nvim-rosepine = {
      url = "github:rose-pine/neovim/v3.0.1";
      flake = false;
    };
    # nvim-mini = {
    #   url = "github:echasnovski/mini.nvim";
    #   flake = false;
    # };
    # nvim-mini-comment = {
    #   url = "github:echasnovski/mini.comment";
    #   flake = false;
    # };
    nvim-comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    nvim-tmux-navigator = {
      url = "github:christoomey/vim-tmux-navigator";
      flake = false;
    };

    nvim-trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    nvim-flutter-tools = {
      url = "github:akinsho/flutter-tools.nvim";
      flake = false;
    };

    nvim-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    nvim-fzf-lua = {
      url = "github:ibhagwan/fzf-lua";
      flake = false;
    };

    nvim-octo = {
      url = "github:pwntester/octo.nvim";
      flake = false;
    };
    
    nvim-nyoom = {
      url = "github:nyoom-engineering/nyoom.nvim";
      flake = false;
    };

    nvim-spaceduck = {
      url = "github:pineapplegiant/spaceduck";
      flake = false;
    };

    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    nvim-spectre = {
      url = "github:nvim-pack/nvim-spectre";
      flake = false;
    };

    nvim-gruvbox = {
      url = "github:morhetz/gruvbox";
      flake = false;
    };

    tmux-dotbar = {
      url = "github:vaaleyard/tmux-dotbar";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ghostty, zen-browser, stylix, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
      inputs.zig.overlays.default
      inputs.rust.overlays.default
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit overlays nixpkgs inputs stylix;
    };
  in {
    nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
      system = "aarch64-linux";
      user   = "cribz";
    };

    nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" rec {
      system = "aarch64-linux";
      user   = "cribz";
    };

    nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
      system = "aarch64-linux";
      user   = "cribz";
    };

    nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
      system = "x86_64-linux";
      user   = "cribz";
    };

    nixosConfigurations.wsl = mkSystem "wsl" {
      system = "x86_64-linux";
      user   = "cribz";
      wsl    = true;
    };

    darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
      system = "aarch64-darwin";
      user   = "cribz";
      darwin = true;
    };
  };
}
