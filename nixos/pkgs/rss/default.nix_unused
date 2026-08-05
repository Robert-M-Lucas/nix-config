{ lib, fetchFromGitHub, rustPlatform, pkgs }:

rustPlatform.buildRustPackage rec {
  pname = "rss";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "Robert-M-Lucas";
    repo = pname;
    rev = "143d263b1a09434f29107e4d95d7756fbeb1c84d";
    hash = "sha256-/w/2z4iqu21zOz9EJuG6FYtGnsxQXroLF81p0M750Ow=";
  };

  cargoHash = "sha256-TuGSmCNDrJ8cHc9YLtXB8bSXgPPB1t1gWMJhTkUWbw4=";

  # meta = {
  #   description = "A fast line-oriented regex search tool, similar to ag and ack";
  #   homepage = "https://github.com/BurntSushi/ripgrep";
  #   license = lib.licenses.unlicense;
  #   maintainers = [];
  # };
}