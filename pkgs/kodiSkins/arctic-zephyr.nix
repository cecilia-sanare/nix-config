{ lib, buildKodiAddon, fetchFromGitHub }:
let
  owner = "beatmasterRS";
  repo = "skin.arctic.zephyr.mod";
in
buildKodiAddon {
  pname = "osmc-skin";
  namespace = repo;
  version = "20.1.0";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "2.0.4";
    sha256 = "sha256-YB7tYSrbtALBbsEOFr7pJmJdleluMgIbFnOzJVaORuQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/${owner}/${repo}";
    description = "...";
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
    license = licenses.cc-by-nc-sa-30;
  };
}