{ lib, ... }: {
  wayland.windowManager.hyprland.settings = {
    config = {
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        numlock_by_default = true;
      };
    };

    gesture = {
      _args = [
        (lib.generators.mkLuaInline ''{
          fingers = 3,
          direction = "horizontal",
          action = "workspace",
        }'')
      ];
    };
  };
}
