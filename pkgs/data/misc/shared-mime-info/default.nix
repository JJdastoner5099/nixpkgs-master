{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, gettext
, itstool
, libxml2
, glib
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info";
  version = "2.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = pname;
    rev = version;
    sha256 = "sha256-cEfknRVtOJykEO9Iqlb0UoiayYtu+ugvmmZqAD5cGnE=";
  };

  patches = [
    # Submitted upstream at
    # https://gitlab.freedesktop.org/xdg/shared-mime-info/-/issues/211
    ./fix-clang-warnings.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) shared-mime-info;

  buildInputs = [
    libxml2
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dupdate-mimedb=true"
  ];

  meta = with lib; {
    description = "A database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.freedesktop.members ++ [ maintainers.mimame ];
    mainProgram = "update-mime-database";
  };
}
