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
  extraConfigVim = ''
      hi clear NeogitDiffDelete
      hi clear NeogitDiffDeleteCursor
      hi clear NeogitDiffDeleteHighlight

      hi link NeogitDiffDelete @diff.minus
      hi link NeogitDiffDeleteCursor @diff.minus
      hi link NeogitDiffDeleteHighlight @diff.minus


      hi clear NeogitDiffAdd
      hi clear NeogitDiffAddCursor
      hi clear NeogitDiffAddHighlight

      hi link NeogitDiffAdd @diff.plus
      hi link NeogitDiffAddCursor @diff.plus
      hi link NeogitDiffAddHighlight @diff.plus

      hi clear NeogitHunkHeader
      hi clear NeogitHunkHeaderCursor
      hi clear NeogitHunkHeaderHighlight

      hi link NeogitHunkHeader @diff.delta
      hi link NeogitHunkHeaderCursor @diff.delta
      hi link NeogitHunkHeaderHighlight @diff.delta

    hi clear NeogitCommitViewHeader
    hi link NeogitCommitViewHeader @diff.delta
  '';
}
