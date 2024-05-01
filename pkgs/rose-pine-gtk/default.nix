{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  jdupes,
  themeVariant ? [],
  iconVariant ? [],
}: let
  inherit (builtins) toString;
  inherit (lib.trivial) checkListOfEnum;
in
  checkListOfEnum "$Rose-Pine: GTK Theme Variants" [
    "Main-B-LB"
    "Main-B"
    "Main-BL-LB"
    "Main-BL"
  ]
  themeVariant
  checkListOfEnum "$RosePine: GTK Theme Variants" [
    ""
    "-Moon"
  ]
  iconVariant
  stdenv.mkDerivation {
    pname = "rose-pine-gtk";
    version = "unstable-2023-02-20";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Rose-Pine-GTK-Theme";
      rev = "95aa1f2b2cc30495b1fc5b614dc555b3eef0e27d";
      hash = "sha256-I9UnEhXdJ+HSMFE6R+PRNN3PT6ZAAzqdtdQNQWt7o4Y=";
    };

    nativeBuildInputs = [jdupes];

    propagatedUserEnvPkgs = [gtk-engine-murrine];

    installPhase = let
      gtkTheme = "RosePine-${toString themeVariant}";
      iconTheme = "Rose-Pine${toString iconVariant}";
    in ''
      runHook preInstall

      mkdir -p $out/share/{icons,themes}
      mkdir $out/share/icons/${iconTheme}
      mkdir $out/share/icons/${iconTheme}/actions
      mkdir $out/share/icons/${iconTheme}/actions/symbolic
      cp $src/icons/${iconTheme}/actions/symbolic/edit-symbolic.svg $out/share/icons/${iconTheme}/actions/symbolic/document-edit-symbolic.svg

      cp -r $src/themes/${gtkTheme} $out/share/themes
      cp -r $src/icons/${iconTheme} $out/share/icons

      runHook postInstall
    '';

    meta = with lib; {
      description = "A GTK theme with the Rosé Pine colour palette.";
      homepage = "https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme";
      license = licenses.gpl3Only;
      platforms = platforms.all;
    };
  }
