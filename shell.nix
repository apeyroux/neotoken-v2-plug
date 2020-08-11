((import ./.).neotoken-v2-plug.components.exes.neotoken-v2-plug // {
  env = (import ./.).shellFor {
    packages = p: [ p.neotoken-v2-plug ];
    exactDeps = true;
    tools = {
      cabal = "3.2.0.0";
      hie = "unstable";
    };
    shellHook = ''
      export HIE_HOOGLE_DATABASE=$(realpath "$(dirname "$(realpath "$(which hoogle)")")/../share/doc/hoogle/default.hoo")
    '';
  };
}).env
