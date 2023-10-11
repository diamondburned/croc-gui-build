{ pkgs ? import <nixpkgs> {} }:

let
	fyne = pkgs.callPackage ./nix/fyne.nix {};
	fyneDeps = import ./nix/fyne-deps.nix { inherit pkgs; };
in

pkgs.mkShell {
	buildInputs = with pkgs; [
		pkgsCross.mingwW64.buildPackages.gcc
	] ++ fyneDeps.buildInputs;

	nativeBuildInputs = with pkgs; [
		fyne
		niv
		go
		gopls
		gotools
	] ++ fyneDeps.nativeBuildInputs;

	CGO_ENABLED = "1";
}
