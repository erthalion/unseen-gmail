with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, base, HaskellNet, HaskellNet-SSL, stdenv }:
             mkDerivation {
               pname = "unseen-gmail";
               version = "0.1.0.0";
               src = ./.;
               isLibrary = false;
               isExecutable = true;
               buildDepends = [ base HaskellNet HaskellNet-SSL ];
               license = stdenv.lib.licenses.gpl3;
             }) {};
in
  pkg.env
