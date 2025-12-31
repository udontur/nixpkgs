{
  lib,
  fetchFromGitHub,
  nodejs_24,
  buildNpmPackage,
}:
let
  ghTag = "ts-v1.4.0";
  ghHash = "sha256-fX4B6osknyyr0a3IadCIdQPR/iL4vbe8iUC/cOtrCVs=";
  npmHash = "sha256-62jtyccDlvqp6OZP0DcmuPBv82xZms1u/m2SEedcHEg=";
in
buildNpmPackage rec {
  pname = "instagram-cli";
  version = ghTag;

  src = fetchFromGitHub {
    owner = "supreme-gg-gg";
    repo = "instagram-cli";
    tag = ghTag;
    hash = ghHash;
  };

  npmDepsHash = npmHash;

  nativeBuildInputs = [
    nodejs_24
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -a "./dist/." "$out/bin"
    cp -a "./node_modules" "$out"

    cat > $out/bin/instagram-cli <<EOF
      #!/bin/sh
      exec "${nodejs_24}/bin/node" "$out/bin/cli.js" "\$@"
    EOF
    chmod +x -R $out/bin
    runHook postInstall
  '';

  meta = {
    mainProgram = "instagram-cli";
    description = "The unofficial CLI and terminal client for Instagram.";
    homepage = "https://github.com/supreme-gg-gg/instagram-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ udontur ];
    platforms = lib.platforms.all;
  };
}
