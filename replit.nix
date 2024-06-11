{ pkgs }: {
  deps = [
    pkgs.wget
    pkgs.nano
    pkgs.bashInteractive
    pkgs.nodePackages.bash-language-server
    pkgs.man
  ];
}
