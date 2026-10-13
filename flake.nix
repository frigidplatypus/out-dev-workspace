{
  description = "Star Wars demo workspace for outl, built against the experimental branch";

  # The outl fork checkout that carries the experimental changes. The fork's
  # own flake keeps its `default` on the pinned upstream release, so this
  # flake names the dev output explicitly: `outl-dev` builds the checked-out
  # ref's tree (the flake's `self`), which is the experimental branch here.
  inputs.outl.url = "github:frigidplatypus/outl/experimental";

  outputs =
    { self, outl }:
    {
      packages =
        let
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
          forSystems =
            f:
            builtins.foldl' (acc: s: acc // { ${s} = f s; }) { } systems;
        in
        forSystems (
          s:
          {
            default = outl.packages.${s}.outl-dev;
            outl = outl.packages.${s}.outl-dev;
          }
        );
    };
}
