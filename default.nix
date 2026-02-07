{ pkgs ? import <nixpkgs> {} }:

pkgs.lua5_4.pkgs.buildLuaPackage {
  pname = "specifications-lua";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.lua5_4 ];

  configurePhase = "true";

  buildPhase = ''
    bash build.sh
  '';

  installPhase = ''
    mkdir -p $out/
    cp -r out/* $out/
    rm -rf out
  '';
}
