{pkgs}: {
  server_name = "nixd";
  package = pkgs.nixd;
  settings = {
    formatting.command = ["alejandra"];
  };
}
