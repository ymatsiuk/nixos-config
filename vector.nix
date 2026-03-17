let
  secrets = import ./secrets.nix;
in
{
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        journald = {
          type = "journald";
        };
      };
      sinks = {
        grafana = {
          auth = {
            strategy = "basic";
            user = secrets.grafana.cloud.user;
            password = secrets.grafana.cloud.token;
          };
          type = "loki";
          inputs = [ "journald" ];
          endpoint = secrets.grafana.cloud.endpoint;
          encoding.codec = "json";
          labels = {
            host = "$HOSTNAME";
          };
        };
      };
    };
  };
}
