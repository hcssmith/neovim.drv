{pkgs}: {
  server_name = "bashls";
  package = pkgs.nodePackages.bash-language-server;
}
