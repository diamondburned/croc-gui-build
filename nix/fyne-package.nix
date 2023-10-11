{
	sources ? import ./sources.nix {},
	nixpkgs ? sources.nixpkgs,
	pkgs ? import nixpkgs {},
	fyne ? pkgs.callPackage ./fyne.nix {},
}:

let
	lib = pkgs.lib;
in

{
	src,
	pname ? "unknown",
	psuffix ? null,
	version ? "0.0.0",
	args,
	outFile,
	stdenv ? pkgs.stdenv,
	buildInputs ? (import ./fyne-deps.nix { inherit pkgs; }).buildInputs,
	vendorSha256 ? lib.fakeSha256,

	GOOS,
	GOARCH,
}:

let
	escapedArgs = lib.concatStringsSep " " (map lib.escapeShellArg args);
	escapedPname = lib.escapeShellArg pname;
	esacpedOutFile = lib.escapeShellArg outFile;

	buildGoModule = pkgs.callPackage "${nixpkgs}/pkgs/build-support/go/module.nix" {
		inherit stdenv;
		go = pkgs.go // {
			inherit GOOS GOARCH;
		};
	};

	out = buildGoModule {
		inherit pname outFile version src vendorSha256 GOOS GOARCH;
	
		buildInputs = with pkgs; [ ] ++ buildInputs;
	
		nativeBuildInputs = with pkgs; [
			go
			fyne
			pkg-config
		];
	
		patchPhase = ''
			rm Makefile
		'';
	
		buildPhase = ''
			fyne package --executable $pname --os $GOOS ${escapedArgs}
			if [[ ! -f $outFile ]]; then
				echo "fyne package failed to produce $outFile"
				ls -la
				exit 1
			fi
		'';
	
		installPhase = ''
			install -Dm755 $outFile $out/$outFile
		'';
	};
in
	out // {
		name = "${pname}-${psuffix}-${version}";
	}
