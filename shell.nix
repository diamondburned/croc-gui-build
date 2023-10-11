{
	sources ? import ./nix/sources.nix {},
	pkgs ? import sources.nixpkgs {},
}:

pkgs.mkShell {
	nativeBuildInputs = with pkgs; [
		niv
	];
}
