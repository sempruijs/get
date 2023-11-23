{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # add more inputs here
  };
  # pass inputs to output function
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
        in {
          packages = rec {
            default = audio-from-yt;
            audio-from-yt = pkgs.writeShellApplication {
              name = "audio-from-yt-wrapper";
              text = "nix run ./audio-from-yt";
            };
            rust-flake = pkgs.writeShellApplication {
              name = "rust-flake-wrapper";
              text = "cp ./flake/rust/flake.nix .";
            };
          };
          devShells = {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [ yt-dlp ffmpeg_6 ];
            };
          };
        };
    };
}
