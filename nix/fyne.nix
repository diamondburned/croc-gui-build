{ lib, buildGoModule }:

let
	sources = import ./sources.nix {};
in

buildGoModule rec {
	pname = "fyne";
	src = sources.fyne;
	version = src.version or src.rev;
	vendorSha256 = "sha256-KzG+hafufYlLMEpN8HCOGpxO1IQ3K+1HJjGwL10pNXI=";

	subPackages = [ "cmd/fyne" ];
}
