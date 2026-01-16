{
  pkgs,
  lib,
  buildNpmPackage,
}:

buildNpmPackage (this: {
  pname = "claude-code-router";
  version = "1.0.72";
  src = pkgs.fetchFromGitHub {
    owner = "musistudio";
    repo = "claude-code-router";
    rev = "8dc0651c123079ed0666b2c9759b5d42d3fdc564";
    hash = "sha256-nONNmWztSxBwX3NlvLuiigkfWcogOpIQuia35ZV767U=";
  };

  npmDeps = null;
  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (this) pname src;
    fetcherVersion = 2;
    hash = "sha256-l4OGGKJS5iz+OAwgH8xJwddSlSVnY4jzppt1wXQd19U=";
  };

  nativeBuildInputs = with pkgs; [
    pnpm_9
    esbuild
    makeBinaryWrapper
    pnpmConfigHook
  ];

  npmConfigHook = pkgs.pnpmConfigHook;
  buildPhase = ''
    runHook preBuild

    esbuild src/cli.ts --bundle --platform=node --outfile=dist/cli.js

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/claude-code-router/dist
    cp dist/cli.js $out/lib/claude-code-router/dist/
    cp node_modules/tiktoken/tiktoken_bg.wasm $out/lib/claude-code-router/dist/
    cp ${this.passthru.ui}/index.html $out/lib/claude-code-router/dist/

    mkdir -p $out/bin
    makeBinaryWrapper ${lib.getExe pkgs.nodejs_24} $out/bin/ccr \
      --add-flags "$out/lib/claude-code-router/dist/cli.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ pkgs.versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru.ui = buildNpmPackage (finalAttrs': {
    pname = this.pname + "-ui";
    inherit (this) version src;

    sourceRoot = "${finalAttrs'.src.name}/ui";

    npmDeps = null;
    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (finalAttrs') pname src sourceRoot;
      fetcherVersion = 2;
      hash = "sha256-ZjYLUec9EADQmKfju8hMbq0y4f1TDVwjbe3yw8Gh4Ac=";
    };

    nativeBuildInputs = [
      pkgs.pnpm_9
      pkgs.pnpmConfigHook
    ];

    npmConfigHook = pkgs.pnpmConfigHook;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp dist/index.html $out/

      runHook postInstall
    '';
  });

  meta = {
    description = "Tool to route Claude Code requests to different models and customize any request";
    homepage = "https://github.com/musistudio/claude-code-router";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prince213
    ];
    mainProgram = "ccr";
  };
})
