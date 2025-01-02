{ lib, pkgs, ... }: {
  systemd.user.services.synergy = {
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    description = "Synergy 3 service";
    serviceConfig.ExecStart = ''${pkgs.synergy}/bin/synergy -c "exec /opt/Synergy/synergy-service -d"'';
    serviceConfig.Restart = "on-failure";
    serviceConfig.RestartSec = 1;
  };
  environment.packages = [ pkgs.synergy ];
}
