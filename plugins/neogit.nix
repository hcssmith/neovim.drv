{pkgs, ...}: {
  pkg = pkgs.vimUtils.buildVimPlugin rec {
    name = "neogit-nightly";
    version = "023a515fa33904e140f3f20a83e6fb1c7b9ffffe";
    pname = "${name}-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "NeogitOrg";
      repo = "neogit";
      rev = "023a515fa33904e140f3f20a83e6fb1c7b9ffffe";
      hash = "sha256-asQ4i03AYwyyMhaAUW9PmH9Kt6s+dBWiy5jv/UEYWQo=";
    };
  };
  name = "neogit";
  opts = {
    integrations.telescope = true;
  };
  keymaps = [
    {
      action = "function () require('neogit').open() end";
      key = "<leader>ng";
    }
  ];
}
