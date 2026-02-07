{
  lua
}:
lua.pkgs.buildLuaPackage {
  pname = "specifications-lua";
  version = "0.1.0";

  src = ./.;

  configurePhase = "true";

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/lib
    make build OUT_DIR=$out/lib

    runHook postBuild
  '';

  installPhase = "true";
}