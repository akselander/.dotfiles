{
  config,
  pkgs,
  ...
}: let
  c = config.colorScheme.palette;
in {
  home.packages = with pkgs; [vesktop];
  impermanence.cache.directories = [".config/vesktop"];
  xdg.configFile."vesktop/themes/base16.css".text =
    /*
    css
    */
    ''
      @import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@300..700&display=swap');
      :root {
        --Chat-Font-Used: 'Fira Code', monospace ;
        --Chat-Font-Size: 14px;

        --font-primary: var(--Chat-Font-Used);
        --font-display: var(--Chat-Font-Used);
        --font-code: var(--Chat-Font-Used);
      }

      .theme-dark, .theme-light {
          --background-primary: #${c.base02};
          --background-secondary: #${c.base01};
          --background-secondary-alt: #${c.base02};
          --channeltextarea-background: #${c.base02};
          --background-tertiary: #${c.base00};
          --background-accent: #${c.base0A};
          --text-normal: #${c.base05};
          --text-spotify: #${c.base0C};
          --text-muted: #${c.base03};
          --text-link: #${c.base0B};
          --background-floating: #${c.base01};
          --header-primary: #${c.base06};
          --header-secondary: #${c.base0C};
          --header-spotify: #${c.base0C};
          --interactive-normal: #${c.base06};
          --interactive-hover: #${c.base0D};
          --interactive-active: #${c.base06};
          --ping: #${c.base08};
          --background-modifier-selected: #${c.base02}b4;
          --scrollbar-thin-thumb: #${c.base00};
          --scrollbar-thin-track: transparent;
          --scrollbar-auto-thumb: #${c.base00};
          --scrollbar-auto-track: transparent;
      }
    '';
}
