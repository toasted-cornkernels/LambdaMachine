# Local speech-to-text server (whisper.cpp) for the voice interface.
# Import only from personal Macs. The config file written here is the
# switch the Emacs / Hammerspoon clients look for; without it they do nothing.
# Everything runs on 127.0.0.1. Models are fetched once at build time from a
# pinned revision and verified by hash.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.voice;

  modelRev = "5359861c739e955e79d9a303bcbc70fb988958b1";
  modelHashes = {
    "large-v3-turbo" = "1fc70f774d38eb169993ac391eea357ef47c88757ef72ee5943879b7e8e2bc69";
    "large-v3-turbo-q5_0" = "394221709cd5ad1f40c46e6031ca61bce88931e6e088c188294c6d5a55ffa7e2";
    "large-v3-turbo-q8_0" = "317eb69c11673c9de1e1f0d459b253999804ec71ac4c23c17ecf5fbe24e259a1";
  };
  model = pkgs.fetchurl {
    name = "ggml-${cfg.model}.bin";
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/${modelRev}/ggml-${cfg.model}.bin";
    sha256 = modelHashes.${cfg.model};
  };

  isAppleSilicon = pkgs.stdenv.hostPlatform.isAarch64;
  logFile = "${config.home.homeDirectory}/Library/Logs/whisper-server.log";
in
{
  options.voice = {
    model = lib.mkOption {
      type = lib.types.enum (builtins.attrNames modelHashes);
      # Intel iMac: CPU only, quantized. Apple Silicon: Metal, full precision.
      default = if isAppleSilicon then "large-v3-turbo" else "large-v3-turbo-q5_0";
    };
    useGpu = lib.mkOption {
      type = lib.types.bool;
      # The AMD GPU's Metal path produces garbage with whisper.cpp; Apple GPUs are fine.
      default = isAppleSilicon;
    };
    threads = lib.mkOption {
      type = lib.types.int;
      default = if isAppleSilicon then 8 else 10;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8178;
    };
    languages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "en"
        "ko"
        "ja"
      ];
    };
    vocabulary = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      description = "Words whisper should expect, by language; sent as its prompt.";
      default = {
        en = [
          "Emacs"
          "ELisp"
          "Nix"
          "nix-darwin"
          "Hammerspoon"
          "Fennel"
          "agent-shell"
          "Magit"
          "evil"
          "whisper.cpp"
          "CodeQL"
        ];
      };
    };
  };

  config = {
    home.packages = [ pkgs.whisper-cpp ];

    launchd.agents.whisper-server = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.whisper-cpp}/bin/whisper-server"
          "--host"
          "127.0.0.1"
          "--port"
          (toString cfg.port)
          "--model"
          "${model}"
          "--threads"
          (toString cfg.threads)
          "--language"
          "auto"
          "--public"
          "/var/empty"
        ]
        ++ lib.optional (!cfg.useGpu) "--no-gpu";
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = logFile;
        StandardErrorPath = logFile;
      };
    };

    xdg.configFile."voice/config.json".text = builtins.toJSON {
      endpoint = "http://127.0.0.1:${toString cfg.port}/inference";
      inherit (cfg) languages model vocabulary;
    };
  };
}
