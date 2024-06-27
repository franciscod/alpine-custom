{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    ddrescue
    expect
    qemu
  ];

  shellHook = ''
  '';
}
