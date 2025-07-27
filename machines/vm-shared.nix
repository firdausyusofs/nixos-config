{ config, pkgs, lib, currentSystem, currentSystemName,... }:

let linuxGnome = false;
in {
  # imports = [
  #   ../modules/specialization/plasma.nix
  #   ../modules/specialization/i3.nix
  #   ../modules/specialization/hyprland.nix
  # ];

  # Be careful updating this.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    # public binary cache that I use for all my derivations. You can keep
    # this, use your own, or toss it. Its typically safe to use a binary cache
    # since the data inside is checksummed.
    settings = {
      substituters = ["https://mitchellh-nixos-config.cachix.org"];
      trusted-public-keys = ["mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="];
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    # Needed for k2pdfopt 2.53.
    "mupdf-1.17.0"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  boot.loader.systemd-boot.consoleMode = "0";

  # Define your hostname.
  networking.hostName = "dev";

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Virtualization settings
  virtualisation.docker.enable = true;
  # virtualisation.lxd = {
  #   enable = true;
  # };

  # Select internationalisation properties.
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      libva-utils
      libva-vdpau-driver
    ];
  };

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # services.displayManager.defaultSession = "none+i3";

  # Enable tailscale. We manually authenticate when we want with
  # "sudo tailscale up". If you don't use tailscale, you should comment
  # out or delete all of this.
  services.tailscale.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;

    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
      pkgs.material-design-icons
      (pkgs.stdenv.mkDerivation {
        pname = "Berkeley-Mono";
        version = "1.0.0";
        src = /home/cribz/Downloads/2507237R56WY3ZV2/TX-02-6YR5N1ZK/BerkeleyMonoTrial-Fixed.otf;
        phases = ["installPhase"];
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp $src $out/share/fonts/opentype/Berkeley-Mono.ttf
        '';
      })
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
    niv
    rxvt-unicode-unwrapped
    xclip
    alsa-utils
    glxinfo
    polybar # TODO: Remove this when using specialization

    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ] ++ lib.optionals (currentSystemName == "vm-aarch64") [
    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    gtkmm3
  ];

  # setup windowing environment
  # services.xserver = lib.mkIf (config.specialisation != {}) {
  #   enable = true;
  #   xkb.layout = "us";
  #   desktopManager.gnome.enable = true;
  #   displayManager.gdm.enable = true;
  # };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  services.xserver = if linuxGnome then {
    enable = true;
    xkb.layout = "us";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  } else {
    enable = true;
    xkb.layout = "us";
    dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
      lightdm.greeters.gtk.cursorTheme = {
        # name = "Bibata-Modern-Ice";
        # package = pkgs.bibata-cursors;
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 48;
      };

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.Add commentMore actions
      sessionCommands = ''
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name ${pkgs.phinger-cursors}/share/icons/capitaine-cursors/cursors/left_ptr &disown
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
    };

    windowManager = {
      i3.enable = true;
    };
  };

  environment.variables = {
    XCURSOR_SIZE = "48";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  services.flatpak.enable = true;

  services.snap.enable = true;

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  services.picom = {
    enable = true;
    fade = true;
    # vSync = true;
    shadow = true;
    fadeDelta = 4 ;
    inactiveOpacity = 1;
    activeOpacity = 1;
    backend = "glx";
    settings = {
      blur = {
        method = "dual_kawase";
        # background = true;
        strength = 8;
      };
    };
  };
}
