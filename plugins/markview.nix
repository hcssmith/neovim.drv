{pkgs, ...}: {
  pkg = (
    pkgs.vimUtils.buildVimPlugin rec {
      name = "markview.nvim";
      version = "f60219dce7283192d549f21847fcf8537bf6d260";
      pname = "${name}-${version}";
      src = pkgs.fetchFromGitHub {
        owner = "OXY2DEV";
        repo = "markview.nvim";
        rev = "v${version}";
        hash = "sha256-E1lHSjbnOOIeieaFJ+INvxJHCbfVS3mwbQ6wrlKeGSQ=";
      };
    }
  );
  optional = true;
  name = "markview";
}
