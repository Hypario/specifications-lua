{
  description = "Lua dev shell with working module loading";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lua = pkgs.lua5_4.withPackages (ps: [
          ps.busted  # for testing
        ]);
      in {
        # ---------- Development shell ----------
        devShell = pkgs.mkShell {
          buildInputs = [
            lua
          ];
        };

        # ---------- Package (LuaRocks-style) ----------
        packages.default = import ./default.nix { inherit pkgs; };
      });
}
