# i3 (X11)
{ pkgs, ... }: {
  specialisation.i3.configuration = {
    # We need an XDG portal for various applications to work properly,
    # such as Flatpak applications.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    services.xserver = {
      enable = true;
      xkb.layout = "us";
      dpi = 220;
      upscaleDefaultCursor = true;

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "fill";
      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;
        lightdm.greeters.gtk.cursorTheme = {
          name = "Vanilla-DMZ";
          package = pkgs.vanilla-dmz;
          size = 64;
        };

        # AARCH64: For now, on Apple Silicon, we must manually set the
        # display resolution. This is a known issue with VMware Fusion.
        sessionCommands = ''
          ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name ${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ/cursors/left_ptr 128 &disown
          ${pkgs.xorg.xset}/bin/xset r rate 200 40
        '';
      };

      windowManager = {
        i3.enable = true;
      };

    };

    environment.variables = {
      XCURSOR_SIZE = "128";
    };
  };
}
