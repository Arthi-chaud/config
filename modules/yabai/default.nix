{ home }:
{
  impurity,
  pkgs,
  ...
}:
if home then
  {
    home.file."clear-empty-spaces.sh" = {
      target = ".config/scripts/clear-empty-spaces.sh";
      source = ./clear-empty-spaces.sh;
      executable = true;
    };
    home.file.".config/yabai/yabairc" = {
      source = impurity.link ./yabairc;
    };
  }
else
  {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
      package = pkgs.yabai.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "asmvik";
          repo = "yabai";
          rev = "477e859";
          hash = "sha256-0rUexr+Gzg6tykTweR4UKkqUCnfZsywnoxZaXNJhIMU=";
        };
      });
      # with pkgs;
      # (pkgs.stdenv.mkDerivation rec {
      #   pname = "yabai";
      #   version = ;
      #
      #   src = pkgs.fetchFromGitHub {
      #     owner = "asmvik";
      #     repo = pname;
      #     rev = version;
      #     hash = "sha256-0rUexr+Gzg6tykTweR4UKkqUCnfZsywnoxZaXNJhIMU=";
      #   };
      #
      #   nativeBuildInputs = with pkgs; [
      #     installShellFiles
      #     xxd
      #   ];
      #
      #   buildInputs = with pkgs; [
      #     apple-sdk_15
      #   ];
      #
      #   # Upstream Makefile races clean-build against linking under parallel make.
      #   enableParallelBuilding = false;
      #
      #   installPhase = ''
      #     runHook preInstall
      #
      #     mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}
      #
      #     cp ./bin/yabai $out/bin/yabai
      #     cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
      #     installManPage ./doc/yabai.1
      #
      #     runHook postInstall
      #   '';
      #
      #   # yabai's makefile builds universal (x86_64 + arm64/arm64e) binaries with
      #   # `xcrun clang`. Collapse it to the host arch and use plain `clang`, since the
      #   # scripting addition (arm64e) is compiled in preBuild with the unwrapped clang,
      #   # which needs the SDK/clang/CUPS include paths passed explicitly.
      #   #
      #   # `-Wl,-no_uuid` is attached to BUILD_FLAGS, which upstream uses only for the
      #   # main binary, whose LC_UUID is otherwise non-deterministic. The scripting
      #   # addition must keep its LC_UUID, as dyld refuses to dlopen a Mach-O that
      #   # lacks one, preventing the scripting addition from injecting.
      #   postPatch =
      #     let
      #       arch = stdenv.hostPlatform.darwinArch;
      #       # The scripting addition is injected into arm64e system processes, so on
      #       # aarch64 it must be arm64e even though the main binary stays arm64.
      #       archSA = "${arch}${lib.optionalString stdenv.hostPlatform.isAarch64 "e"}";
      #       clangFlags = lib.concatStringsSep " " [
      #         "-isystem $(SDKROOT)/usr/include"
      #         "-isystem ${llvmPackages.libclang.lib}/lib/clang/*/include"
      #         "-isystem ${lib.getDev cups}/include"
      #         "-F$(SDKROOT)/System/Library/Frameworks"
      #         "-L$(SDKROOT)/usr/lib"
      #       ];
      #     in
      #     ''
      #       substituteInPlace makefile \
      #         --replace-fail "-arch x86_64 -arch arm64e" "-arch ${archSA}" \
      #         --replace-fail "-arch x86_64 -arch arm64" "-arch ${arch} -Wl,-no_uuid" \
      #         --replace-fail 'xcrun clang' 'clang ${clangFlags}'
      #     '';
      #
      #   # The cc-wrapper can't target arm64e, so build the scripting addition (the only
      #   # arm64e part) with the unwrapped clang.
      #   preBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
      #     make ./src/osax/payload_bin.c ./src/osax/loader_bin.c "PATH=${bintools-unwrapped}/bin:${llvmPackages.clang-unwrapped}/bin:$PATH"
      #   '';
      #
      #   doInstallCheck = true;
      # }

    };
  }
