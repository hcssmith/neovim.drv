{pkgs, ...}: {
  pkg = (
    pkgs.vimUtils.buildVimPlugin rec {
      name = "markview.nvim";
      version = "823a3a2f13c6e28e8497641882034901b97ea513";
      pname = "${name}-${version}";
      src = pkgs.fetchFromGitHub {
        owner = "OXY2DEV";
        repo = "markview.nvim";
        rev = "v${version}";
        hash = "sha256-mSkDZokOsoQ9wwSdLkL/FDR5NGkHHc1SIhOmDFTmiiM=";
      };
    }
  );
  name = "markview";
  opts = {
    list_items = {
      enable = true;
      marker_minus = {
        add_padding = false;
      };
      marker_plus = {
        add_padding = false;
      };
      marker_star = {
        add_padding = false;
      };
      marker_dot = {
        add_padding = false;
      };
    };
  };
}
