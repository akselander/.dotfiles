{pkgs, ...}: let
  tmux = "${pkgs.tmux}/bin/tmux";
  fzf = "${pkgs.fzf}/bin/fzf";
  sessionizerScript =
    pkgs.writeShellScript "sessionizer"
    ''
      if [ $# -eq 1 ]; then
          selected=$1
      else
          selected=$(find ~/work/flyhomes/zerodownhomes ~/projects ~/ ~/work ~/personal -mindepth 1 -maxdepth 1 -type d | ${fzf})
      fi


      if [ -z $selected ]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [ -z $TMUX ] && [ -z $tmux_running ]; then
          ${tmux} new-session -s $selected_name -c $selected
          exit 0
      fi

      if ! ${tmux} has-session -t=$selected_name 2> /dev/null; then
          ${tmux} new-session -ds $selected_name -c $selected
      fi
      if [ -z $TMUX ]; then
        ${tmux} attach-session -t $selected_name
        exit 0
      fi

      ${tmux} switch-client -t $selected_name
    '';
in {
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -ga terminal-overrides ",screen-256color*:Tc"
      set-option -g default-terminal "screen-256color"
      set -s escape-time 0

      set -g status-style 'bg=#333333 fg=#5eacd3'

      set -g base-index 1

      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind -r D neww -c "#{pane_current_path}" "[ -e TODO.md ] && nvim TODO.md || nvim ~/.dotfiles/personal/todo.md"

      bind-key -r f run-shell "${tmux} neww ${sessionizerScript}"

      bind-key -r G run-shell "${sessionizerScript} ~/work/zerodownhomes/curb"
      bind-key -r C run-shell "${sessionizerScript} ~/work/zerodownhomes/foyer"
      # bind-key -r R run-shell "${sessionizerScript} ~/work"
      # bind-key -r L run-shell "${sessionizerScript} ~/work"
      # bind-key -r H run-shell "${sessionizerScript} ~/personal"
      # bind-key -r T run-shell "${sessionizerScript} ~/personal"
      # bind-key -r N run-shell "${sessionizerScript} ~/personal"
      # bind-key -r S run-shell "${sessionizerScript} ~/personal"
    '';
  };
  programs.fish = {
    interactiveShellInit =
      /*
      fish
      */
      ''
        bind \cf ${sessionizerScript}
      '';
  };
  programs.neovim = {
    extraLuaConfig =
      /*
      lua
      */
      ''
        vim.keymap.set("n", "<C-f>", "<cmd>silent !${tmux} neww ${sessionizerScript}<CR>")
      '';
  };
}
