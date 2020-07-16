{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [(
    # Urbit overlay since the official package:
    # 1. doesn't fucking build
    # 2. is as old as my dead forefathers
    self: super: with import <nixpkgs> {}; {
      urbit = super.urbit.override {
        meta = with stdenv.lib; {
          description = "A personal server operating function";
          homepage = "https://urbit.org";
          license = licenses.mit;
          maintainers = with maintainers; [ jtobin ];
          platforms = with platforms; linux ++ darwin;
        };

        pname = "urbit";
        version = "0.10.7";

        src = fetchFromGitHub {
          owner = "urbit";
          repo = "urbit";

          # "271abcd3e76cc0a3d7d37b4efdfe3d73c62a1e0b";
          rev = "${pname}-v${version}";

          sha256 = "1w61w48173pd9gfx4ghf9c4bbjy3hkhdzh778igsv974r29bagrr";
          fetchSubmodules = true;
        };
      };
    }
  )];
}
