{pkgs}: {
  server_name = "nixd";
  package = pkgs.nixd;
  settings = {
    formatting.command = ["alejandra"];
    diagnostic.suppress = ["sema-escaping-with"];
  };
}
