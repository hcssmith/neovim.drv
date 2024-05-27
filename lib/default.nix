{
  supportedSystems,
  nixpkgs,
  overlays,
  ...
}: rec {
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

  nixpkgsFor = forAllSystems (
    system:
      import nixpkgs {
        inherit system;
        overlays = overlays;
      }
  );

  mkNeovimWrap = import ./mkNeovimWrap.nix;
}
