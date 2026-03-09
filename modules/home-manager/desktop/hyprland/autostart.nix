{ config, pkgs, ... }:
let
  inherit (config.omanix.activeTheme.assets) wallpaper;
in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_THEME XCURSOR_SIZE GDK_SCALE HYPRCURSOR_THEME HYPRCURSOR_SIZE"
      "hypridle"
      "mako"
      "swayosd-server"
      "systemctl --user start hyprpolkitagent"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill"
    ];
  };
}
