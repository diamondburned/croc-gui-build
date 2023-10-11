{
	sources ? import ./nix/sources.nix {},
	nixpkgs ? sources.nixpkgs,
	pkgs ? import nixpkgs {},
}:

let
	fynePackage = import ./nix/fyne-package.nix {
		inherit sources nixpkgs pkgs;
		fyne = pkgs.callPackage ./nix/fyne.nix {};
	};

	sources = import ./nix/sources.nix {};

	crocgui =
		{ GOOS, GOARCH, ... }@args:

		fynePackage (rec {
			src = sources.crocgui;
			pname = "crocgui";
			psuffix = "${GOOS}-${GOARCH}";
			version = src.version or src.rev;
			args = [
				"--icon" "metadata/en-US/images/icon.png"
				"--appID" "com.github.howeyc.crocgui"
			];
			vendorSha256 = "sha256-+J2DhBVALTLVJtXFwkp2NgkkGkZ9s8VtxLyMHBPJUm8=";
		} // args);
in

with pkgs;

# TODO: remove this once 
assert stdenv.isLinux;

{
	windows-amd64 = crocgui {
		GOOS = "windows";
		GOARCH = "amd64";
		stdenv = pkgsCross.mingwW64.stdenv;
		outFile = "crocgui.exe";
	};
	linux-amd64 = crocgui {
		GOOS = "linux";
		GOARCH = "amd64";
		stdenv = pkgsCross.gnu64.stdenv;
		outFile = "crocgui.tar.xz";
	};
	linux-arm64 = crocgui {
		GOOS = "linux";
		GOARCH = "arm64";
		stdenv = pkgsCross.aarch64-multiplatform.stdenv;
		outFile = "crocgui.tar.xz";
		buildInputs =
			let
				fyneDeps = import ./nix/fyne-deps.nix {
					pkgs = pkgs.pkgsCross.aarch64-multiplatform;
				};
			in
				fyneDeps.buildInputs;
	};
	darwin-arm64 = crocgui {
		GOOS = "darwin";
		GOARCH = "arm64";
		stdenv = pkgsCross.aarch64-darwin.stdenv;
		outFile = "crocgui.tar.xz";
	};
}
