# Dotfiles

Here is the configuration for all my machines powered by NixOS and Home Manager.

## Structure


```
├── flake.nix                           # Entrypoint for hosts and home configs
│
├── hosts                               # Per host configs
│   ├── common                          # Shared configs for all hosts
│   ├── optional                        # Opt-in configs
│   ├── [hostname]                      # Hostname config
│   │   ├── default.nix                 # Config entryfile
│   │   ├── hardware-configuration.nix  # Hardware specific config
│   │   ├── disko.nix                   # Hostname specific disk setup
│   │   ├── ssh_host_ed25519_key.pub    # Public hostname key
│
├── home                                # Home manager configs
│   ├── [username]                      # Per user home manager configs
│   │   ├── [hostname].nix              # Per machine home manager configs
│   │   ├── global                      # Collection of features shared by all hosts
│   │   ├── features                    # Opt in features used by hosts
│
├── modules                             # Custom modules
│   ├── home-manager
│   ├── nixos
│
├── overlays                            # Patches and version overrides
├── pkgs                                # Custom packages
```

