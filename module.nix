{ lib, pkgs, ... }:
let synergy = pkgs.callPackage ./env.nix { };
in {
  systemd.user.tmpfiles.rules = [
    "d /.synergy"
  ];
  systemd.user.services.synergy = {
    description = "Synergy 3 service";

    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    wantedBy = [ "graphical-session.target" ];

    path = [ pkgs.coreutils synergy ];
    script = ''
      synergy-service -d
    '';
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  # systemd.services.synergy = {
  #   wantedBy = [ "graphical.target" ];
  #   description = "Synergy 3 Login service";
  #   serviceConfig.ExecStart = ''
  #     ${pkgs.synergy}/bin/synergy-env -c '/opt/Synergy/resources/services/system/loginLauncher.sh'
  #   '';
  #   serviceConfig.Restart = "on-failure";
  #   serviceConfig.RestartSec = 1;
  # };

  networking.firewall.allowedTCPPorts = [ 24800 24802 24804 ];
  environment.systemPackages = [ synergy ];
}
