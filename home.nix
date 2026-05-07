{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "nikitab";
  home.homeDirectory = "/home/nikitab";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # -- System --
    git
    curl
    gnutar
    gnumake
    rsync
    p7zip
    findutils

    # -- CLI Tools --
    neovim
    bat
    lsd
    fd
    btop
    superfile
    lazygit
    lazydocker
    (ollama.override { acceleration = "rocm"; })

    # -- Apps --
    kitty
    cmus
    telegram-desktop
    keepassxc
    obsidian

    # -- Utilities --
    udiskie
    openvpn
    ddccontrol
    docker
    fnm
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Batiukhno Nikita";
        email = "nikita@batyukhno-dev.ru";
      };
      init.defaultBranch = "master";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };


  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      rm = "rmt";
      cat = "bat";
      find = "fd";
      ls = "lsd";

      icat = "kitten icat";
      dcat = "kitten diff";
      fcat = "kitten choose-files";

      cssh = "kitten ssh";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git-auto-fetch"
        "git"
        "npm"
        "yarn"
        "docker"
        "command-not-found"
        "safe-paste"
        "gradle-completion"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
  };

  xdg.configFile = let 
    repoUrl = "https://github.com/HardKot/batiukhno_dots.git";
    in {
      "nvim".source = builtins.fetchGit {
        url = repoUrl;
        ref = "nvim";
      };
      "hypr".source = builtins.fetchGit {
        url = repoUrl;
        ref = "hyperland";
      };
      "waybar".source = builtins.fetchGit {
        url = repoUrl;
        ref = "waybar";
      };
      "kitty".source = builtins.fetchGit {
        url = repoUrl;
        ref = "kitty";
      };
      "rofi".source = builtins.fetchGit {
        url = repoUrl;
        ref = "rofi";
      };
    };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;   
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
  };


  home.file = {
  };
  # home.file.".p10k.zsh".source = ~/Scripts/zsh/.p10k.zsh;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # ==========================================
  # Управление стандартными сервисами (Syncthing)
  # ==========================================
  services.syncthing = {
    enable = true;
    # Добавляет иконку в системный трей (Waybar)
    tray.enable = true;
  };

  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama Local AI Server";
      After = ["network.target"];
    };
    Service = {
      ExecStart = "${pkgs.ollama.override { acceleration = "rocm"; }}/bin/ollama serve";
      Restart = "always";
      Environment = [
        "OLLAMA_HOST=127.0.0.1:11434" 
        "HSA_OVERRIDE_GFX_VERSION=10.3.0"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Change wallpaper with time";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "%h/Scripts/commands/my-change-wallpaper";
    };
  };

  systemd.user.timers.wallpaper = {
    Unit = {
      Description = "Change wallpaper with time";
    };
    Timer = {
      OnCalendar = "*:0/5";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  programs.home-manager.enable = true;
}