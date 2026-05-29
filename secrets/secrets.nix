let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILA0+MyUCeN/XMZPefsTBAe6XpSXoioIiJtiZTJZW/Mv";
in {
  "restic-env.age".publicKeys = [ key ];
}

