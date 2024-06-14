{
  buildGrammar,
  pkgs,
  ...
}: {
  tree-sitter-nu = buildGrammar {
    language = "nu";
    version = "0.0.0+64e1677";
    src = pkgs.fetchFromGitHub {
      owner = "LhKipp";
      repo = "tree-sitter-nu";
      rev = "ef943c6f2f7bfa061aad7db7bcaca63a002f354c";
      hash = "sha256-U7IHAXo3yQgbLv7pC1/dOa/cXte+ToMc8QsDEiCMSRg=";
    };
  };
}
