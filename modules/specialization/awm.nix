# AWM specialization
{ pkgs, ... }: {
  specialisation.awm.configuration = {
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

      # displayManager = {
      #   defaultSession = "none+awesome";
      #   lightdm.enable = true;
      #   lightdm.greeters.gtk.cursorTheme = {
      #     name = "Vanilla-DMZ";
      #     package = pkgs.vanilla-dmz;
      #     size = 128;
      #   };
      #
      #   sessionCommands = ''
      #     ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name ${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ/cursors/left_ptr &disown
      #     ${pkgs.xorg.xset}/bin/xset r rate 200 40
      #   '';
      # };

      displayManager.sddm.enable = true;
      windowManager.awesome.enable = true;
    };
  };

  environment.variables = {
    XCURSOR_SIZE = "48";
  };
}
