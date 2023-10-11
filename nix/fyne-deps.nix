{ pkgs }:

with pkgs; {
	buildInputs = [
		xorg.libX11.dev xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXrandr
		xorg.libXxf86vm libglvnd libxkbcommon wayland
	];

	nativeBuildInputs = [
		pkg-config
	];
}
