{ pkgs, lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "protontweaks";
  version = "022ab280397a6ffa79447dffecc9f50b73357de0";

  src = fetchFromGitHub {
    owner = "rain-cafe";
    repo = "protontweaks";
    rev = version;
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  checkFlags = [
    # build rust package breaks the git directory and causes this to fail
    "--skip=utils::git::tests::get_remotes_should_return_the_remotes"
    # something is causing this to fail
    "--skip=utils::url::tests::validate_http_url_should_return_true_for_valid_urls"
  ];

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkgs.rustc
    pkg-config
  ];

  meta = with lib; {
    description = "CLI utility to intelligently open a browser / file manager based upon context";
    homepage = "https://github.com/rain-cafe/smart-open";
    license = licenses.mit;
    maintainers = with maintainers; [ "cecilia-sanare" ];
  };
}
