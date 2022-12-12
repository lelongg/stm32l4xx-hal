let
  rust-overlay = builtins.fetchTarball {
    url =
      "https://github.com/oxalica/rust-overlay/tarball/f45f856ae5a9fe2c48d756fa17bb9c5b3b8070c5";
    sha256 = "sha256:152pw4a1vs4kiwfmncsc9d4zgd3v1li09adqm9ssq62jmxvzz217";
  };
  pkgs = import <nixpkgs> { overlays = [ (import (rust-overlay)) ]; };
in with pkgs;
let
  rustPlatform = pkgs.rust-bin.stable.latest;
  rust = rustPlatform.default.override {
    extensions = [ "rust-src" "clippy" "rustfmt" "llvm-tools-preview" ];
    targets = [ "x86_64-unknown-linux-gnu" "thumbv7em-none-eabihf" ];
  };
in mkShell {
  buildInputs = [ clang rust openssl pkgconfig openocd just mold ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
}
