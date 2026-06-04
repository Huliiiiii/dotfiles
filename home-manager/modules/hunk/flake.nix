{
  description = "Local hunkdiff package";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      hunk = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "hunk";
        version = "0.10.0";

        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/hunkdiff/-/hunkdiff-${finalAttrs.version}.tgz";
          hash = "sha256-wOp9cLyfE6PM+KLhxp8v1NOuGQ4Y+RygHIGdBdqTthY=";
        };

        binary = pkgs.fetchurl {
          url = "https://registry.npmjs.org/hunkdiff-linux-x64/-/hunkdiff-linux-x64-${finalAttrs.version}.tgz";
          hash = "sha256-ICkeeCq8X7czMDtVBH3P5lPDhSrgueZMeQb0QwTcfSA=";
        };

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          makeWrapper
        ];

        buildInputs = [ pkgs.glibc ];
        dontStrip = true;

        unpackPhase = ''
          runHook preUnpack

          mkdir -p hunkdiff hunkdiff-linux-x64
          tar -xzf $src -C hunkdiff --strip-components=1
          tar -xzf $binary -C hunkdiff-linux-x64 --strip-components=1

          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib/node_modules/hunkdiff $out/lib/node_modules/hunkdiff-linux-x64 $out/bin
          cp -R hunkdiff/. $out/lib/node_modules/hunkdiff/
          cp -R hunkdiff-linux-x64/. $out/lib/node_modules/hunkdiff-linux-x64/
          chmod +x $out/lib/node_modules/hunkdiff-linux-x64/bin/hunk

          makeWrapper ${lib.getExe pkgs.nodejs_24} $out/bin/hunk \
            --add-flags "$out/lib/node_modules/hunkdiff/bin/hunk.cjs"

          runHook postInstall
        '';

        meta = {
          description = "Desktop-inspired terminal diff viewer for understanding agent-authored changesets";
          homepage = "https://github.com/modem-dev/hunk";
          license = lib.licenses.mit;
          mainProgram = "hunk";
          platforms = [ system ];
        };
      });
    in
    {
      packages.${system} = {
        default = hunk;
        hunk = hunk;
      };
    };
}
