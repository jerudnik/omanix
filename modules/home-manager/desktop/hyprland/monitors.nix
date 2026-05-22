{ config, lib, ... }:
let
  cfg = config.omanix;
  mkLua = lib.generators.mkLuaInline;

  workspaceRules = lib.flatten (
    lib.imap0 (
      idx: mon:
      let
        base = idx * 10;
      in
      lib.imap1 (
        wsIdx: _:
        {
          _args = [
            (mkLua ''{
              workspace = "${toString (base + wsIdx)}",
              monitor = "${mon.name}"${if wsIdx == 1 then '',
              default = true'' else ""},
            }'')
          ];
        }
      ) (lib.range 1 mon.workspaceCount)
    ) cfg.monitors
  );

  explicitMonitorLines = lib.filter (
    mon: mon.resolution != null || mon.refreshRate != null
  ) cfg.monitors;

  mkMonitorSpec =
    mon:
    let
      res = if mon.resolution != null then mon.resolution else "highres";
      rate = if mon.refreshRate != null then "@${toString mon.refreshRate}" else "";
      scale = toString cfg.monitor.scale;
    in
    {
      _args = [
        (mkLua ''{
          output = "${mon.name}",
          mode = "${res}${rate}",
          position = "auto",
          scale = "${scale}",
        }'')
      ];
    };
in
{
  options.omanix.monitors = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Monitor name (e.g., DP-2, HDMI-A-1). Use `hyprctl monitors` to find yours.";
            example = "DP-2";
          };
          resolution = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Override resolution (e.g., \"2560x1440\"). Null = use Hyprland preferred.";
            example = "2560x1440";
          };
          refreshRate = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = "Override refresh rate in Hz (e.g., 144). Null = use Hyprland preferred.";
            example = 144;
          };
          workspaceCount = lib.mkOption {
            type = lib.types.int;
            default = 5;
            description = "Number of workspaces for this monitor (default: 5).";
          };
        };
      }
    );
    default = [ ];
    description = ''
      Configure monitors for workspace management and display settings.
      Each monitor gets its own set of workspaces (1-5 by default).
      Press Super+1-5 to access workspaces on the currently focused monitor.

      Setting resolution or refreshRate generates an explicit Hyprland monitor
      line for that display. Monitors without these set fall through to the
      catch-all line in visuals.nix (highres, auto scale).

      Example:
        omanix.monitors = [
          { name = "DP-2";     resolution = "2560x1440"; refreshRate = 144; }
          { name = "HDMI-A-2"; resolution = "2560x1440"; refreshRate = 144; }
        ];
    '';
  };

  config = lib.mkIf (cfg.monitors != [ ]) {
    wayland.windowManager.hyprland.settings = lib.mkMerge [
      { workspace_rule = workspaceRules; }
      (lib.mkIf (explicitMonitorLines != [ ]) {
        monitor = map mkMonitorSpec explicitMonitorLines;
      })
    ];
  };
}
