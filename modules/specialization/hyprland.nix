# Hyprland
{ pkgs, ... }: {
 specialisation.hyprland = {
    configuration = {
      # 1. Enable Hyprland & Wayland Essentials
      programs.hyprland = {
        enable = true;
        # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # Uncomment if using hyprland flake input
        xwayland.enable = true; # Enable XWayland for X11 app compatibility
        # nvidiaPatches = true; # Uncomment if using Nvidia proprietary drivers
      };

      # 2. Enable PipeWire for Audio & Screen Sharing (Recommended for Wayland)
      # sound.enable = false; # Disable legacy sound servers if necessary
      # security.rtkit.enable = true; # RealtimeKit essential for PipeWire performance
      # services.pipewire = {
      #   enable = true;
      #   alsa.enable = true;
      #   alsa.support32Bit = true; # If you need 32-bit ALSA support (e.g., Steam)
      #   pulse.enable = true;    # Enable PulseAudio emulation
      #   jack.enable = true;     # Enable JACK emulation if needed
      #   # Use WirePlumber as the session manager (recommended)
      #   wireplumber.enable = true; 
      # };

      # 3. Enable XDG Portals (Crucial for screen sharing, file pickers etc. on Wayland)
      xdg.portal = {
        enable = true;
        # The Hyprland NixOS module should enable xdg-desktop-portal-hyprland automatically.
        # However, XDPH doesn't provide a file picker, so add one like GTK or KDE's.
        extraPortals = with pkgs; [ 
          xdg-desktop-portal-gtk 
          # xdg-desktop-portal-hyprland
          # xdg-desktop-portal-kde # if you prefer KDE apps/picker
        ];
        config.common.default = "*";
        # Optional: Hint GTK apps to use portals
        # gtkUsePortal = true; 
      };
      
      # 4. Environment variables specific to the Hyprland session
      environment.sessionVariables = {
         NIXOS_OZONE_WL = "1";         # Hint for Electron apps (VSCode, Discord) to use Wayland
         WLR_NO_HARDWARE_CURSORS = "1"; # Set if you have cursor issues (esp. NVIDIA)
         WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Set if you have rendering issues (esp. NVIDIA)
         # MOZ_ENABLE_WAYLAND = "1";    # Usually automatic now for Firefox, but can be set explicitly

         XDG_SESSION_TYPE = "wayland"; # Set session type to Wayland
         XDG_CURRENT_DESKTOP = "Hyprland"; # Set current desktop environment
         XDG_SESSION_DESKTOP = "Hyprland"; # Set session desktop

         QT_QPA_PLATFORM = "wayland"; # Set Qt apps to use Wayland
         GDK_BACKEND = "wayland"; # Set GTK apps to use Wayland

         LIBGL_ALWAYS_SOFTWARE = "1"; # Force software rendering (if needed)

         # DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${pkgs.lib.getUserId "greeter"}/bus"; # Set DBUS session bus address
      };

      environment.etc."drirc".text = ''
        <driconf>
          <device>
            <application name="default">
            </application>
          </device>
        </driconf>
      '';

      # 5. Display Manager (Choose ONE or none for TTY login)
      services.xserver = {
        enable = true; # Usually needed even for Wayland DMs for setup/services

        # Option A: GDM (Often works well, ensure Wayland session is enabled)
        displayManager.gdm = {
          enable = true;
          wayland = true; # Explicitly enable Wayland sessions
        };
        videoDrivers = [ "modesetting" ];
        desktopManager.gnome.enable = false; # Disable GNOME DE if enabled globally

        # Option B: SDDM (Needs explicit Wayland enablement)
        # displayManager.sddm = {
        #   enable = true;
        #   wayland.enable = true;
        # };
        # desktopManager.plasma5.enable = false; # Disable Plasma if enabled globally

        # Option C: greetd (Minimal, flexible; requires a greeter)
        # displayManager.greetd = {
        #   enable = true;
        #   settings = {
        #     default_session = {
        #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        #       user = "greeter"; # System user for the greeter
        #     };
        #   };
        # };
        # users.users.greeter = { # Define the greeter user if using greetd
        #   isSystemUser = true;
        #   group = "greeter";
        # };
        # users.groups.greeter = {};

        # Option D: No Display Manager (Login via TTY and run `exec Hyprland`)
        # displayManager.gdm.enable = false; # Ensure others are disabled
        # displayManager.sddm.enable = false; 
        # displayManager.greetd.enable = false;
      };


      # 6. Install Hyprland Ecosystem Packages & Common Tools
      environment.systemPackages = with pkgs; [
        # Core Hyprland ecosystem
        waybar          # Status bar
        wofi            # Application launcher (Wayland native Rofi fork)
        kdePackages.dolphin         # File manager (Wayland native)
        # rofi-wayland  # Alternative Wayland Rofi
        wl-clipboard    # Wayland clipboard utilities (wl-copy/wl-paste)
        wlogout         # Wayland logout menu
        swaylock-effects # Screen locker (or swaylock)
        swayidle        # Idle management daemon
        grim            # Screenshot tool (full screen/window)
        slurp           # Screenshot tool (region selection)
        # mako          # Notification daemon (or dunst)
        hyprpaper       # Wallpaper utility
        hyprpicker      # Color picker
        cliphist        # Clipboard history manager
        foot            # Terminal emulator (Wayland native)
        hyprpaper       # Wallpaper manager

        # Terminals (Wayland native preferred)
        # kitty
        # alacritty
        # foot

        # Other useful GUI/CLI tools
        # pavucontrol     # PulseAudio Volume Control (works with PipeWire Pulse)
        # networkmanagerapplet # GUI for NetworkManager in system tray
        # brightnessctl   # Control screen brightness
        # playerctl       # Control media players
        # thunar          # File manager (or dolphin, nautilus, etc.)
        # ... your preferred browser, text editor, etc.
      ];

      # 7. Fonts (ensure you have some fonts installed)
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        font-awesome # Often used for icons in waybar/rofi
      ];
      
      # 8. Optional: Explicitly disable services/settings from the base config
      # If your base config enables something conflicting (like another WM/DE), disable it here.
      # Example: services.xserver.windowManager.i3.enable = false;
      # Example: programs.kdeconnect.enable = false; 

    }; # End of specialisation.hyprland.configuration
  };
}
