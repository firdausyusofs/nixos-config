{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/zsh" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # programs.fish.enable = true;
  programs.zsh.enable = true;

  users.users.cribz = {
    isNormalUser = true;
    home = "/home/cribz";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$l.Iq4TwwIvD1mJYe$fLTqDXUFMWsZQTzUxVjW3QMp3yHghc8M4V86p272O3MFa6Ovk1x1ryOgW1TRp8c2/UeGwZJzwx2ckg.ALKzdH/";
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix { inherit inputs; })
  ];
}
