# Local speech-to-text server (whisper.cpp) for the voice interface, and local
# language models (llama.cpp) that turn free phrasing into existing commands.
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

  # Chosen by benchmark on the iMac (24 en/ko/ja requests): Qwen3-4B-2507
  # picked best (19/24, ~6 s on CPU); EmbeddingGemma ranks commands for it.
  llmModels = {
    chat = pkgs.fetchurl {
      name = "Qwen3-4B-Instruct-2507-Q4_K_M.gguf";
      url = "https://huggingface.co/unsloth/Qwen3-4B-Instruct-2507-GGUF/resolve/a06e946bb6b655725eafa393f4a9745d460374c9/Qwen3-4B-Instruct-2507-Q4_K_M.gguf";
      sha256 = "3605803b982cb64aead44f6c1b2ae36e3acdb41d8e46c8a94c6533bc4c67e597";
    };
    embeddings = pkgs.fetchurl {
      name = "embeddinggemma-300M-Q8_0.gguf";
      url = "https://huggingface.co/ggml-org/embeddinggemma-300M-GGUF/resolve/0f741b5a6585bd53aeb15cd1372c56f2a0f65e12/embeddinggemma-300M-Q8_0.gguf";
      sha256 = "b5ce9d77a3fc4b3b39ccb5643c36777911cc4eb46a66962eadfa3f5f60490d63";
    };
  };

  isAppleSilicon = pkgs.stdenv.hostPlatform.isAarch64;
  logDir = "${config.home.homeDirectory}/Library/Logs";
  logFile = "${logDir}/whisper-server.log";

  llamaAgent = name: port: extraArgs: {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.llama-cpp}/bin/llama-server"
        "--host"
        "127.0.0.1"
        "--port"
        (toString port)
        "--threads"
        (toString cfg.threads)
        "--parallel"
        "1"
        "--no-webui"
        # The Intel iMac's AMD GPU is unusable (see whisper); Apple GPUs are fine.
        "--n-gpu-layers"
        (if cfg.useGpu then "99" else "0")
      ]
      ++ extraArgs;
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      StandardOutPath = "${logDir}/${name}.log";
      StandardErrorPath = "${logDir}/${name}.log";
    };
  };
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
    llm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Run local models that map free phrasing to existing commands.";
      };
      chatPort = lib.mkOption {
        type = lib.types.port;
        default = 8179;
      };
      embeddingsPort = lib.mkOption {
        type = lib.types.port;
        default = 8180;
      };
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

    launchd.agents.llama-chat = lib.mkIf cfg.llm.enable (
      llamaAgent "llama-chat" cfg.llm.chatPort [
        "--model"
        "${llmModels.chat}"
        "--ctx-size"
        "4096"
      ]
    );

    launchd.agents.llama-embeddings = lib.mkIf cfg.llm.enable (
      llamaAgent "llama-embeddings" cfg.llm.embeddingsPort [
        "--model"
        "${llmModels.embeddings}"
        "--embedding"
        # A batch of command descriptions goes through in one pass.
        "--ctx-size"
        "8192"
        "--batch-size"
        "8192"
        "--ubatch-size"
        "8192"
      ]
    );

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

    xdg.configFile."voice/config.json".text = builtins.toJSON (
      {
        endpoint = "http://127.0.0.1:${toString cfg.port}/inference";
        inherit (cfg) languages model vocabulary;
      }
      // lib.optionalAttrs cfg.llm.enable {
        llm = {
          chat = "http://127.0.0.1:${toString cfg.llm.chatPort}/v1/chat/completions";
          embeddings = "http://127.0.0.1:${toString cfg.llm.embeddingsPort}/v1/embeddings";
        };
      }
    );
  };
}
