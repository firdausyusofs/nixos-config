{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware/pc.nix
    # Optionally, you can import shared modules here if you want
    ../modules/specialization/plasma.nix
    ../modules/specialization/i3.nix
    ../modules/specialization/hyprland.nix
  ];

  # Set your hostname
  networking.hostName = "dev";

  # Set your timezone
  time.timeZone = "Asia/Kuala_Lumpur";

  # Set your network interface (replace with your actual interface name)
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true; # or wlp2s0 for WiFi

  # Enable firewall for real hardware
  networking.firewall.enable = true;

  # Enable sound
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Sudo without password (optional, for convenience)
  security.sudo.wheelNeedsPassword = false;

  # Nix settings
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      substituters = ["https://mitchellh-nixos-config.cachix.org"];
      trusted-public-keys = [
        "mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="
      ];
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "mupdf-1.17.0"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "0";

  # Internationalization
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
    };
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      libva-utils
      libva-vdpau-driver
    ];
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
      pkgs.material-design-icons
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
    niv
    rxvt-unicode-unwrapped
    xclip
    alsa-utils
    glxinfo
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];

  # setup windowing environment
  services.xserver = lib.mkIf (config.specialisation != {}) {
    enable = true;
    xkb.layout = "us";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # Enable Tailscale if you use it
  services.tailscale.enable = true;

  # Enable SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Enable Flatpak and Snap
  services.flatpak.enable = true;
  services.snap.enable = true;

  # Picom compositor (optional, for i3/Hyprland)
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    fadeDelta = 4;
    inactiveOpacity = 1;
    activeOpacity = 1;
    backend = "glx";
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 8;
      };
    };
  };

  # Set your NixOS state version (match your first install)
  system.stateVersion = "20.09";
}
