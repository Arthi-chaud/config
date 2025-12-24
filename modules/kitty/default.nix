{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Latte"; # TODO: Dark Theme: "Catppuccin-Mocha"
    settings = {
      enable_audio_bell = false;
      hide_window_decorations = "titlebar-only"; # NOTE: "yes" remove border radius

      font_size = 14;
      window_padding_width = 5;
      macos_option_as_alt = "yes";
    };
    extraConfig = ''
      map cmd+1 goto_tab 1
      map cmd+2 goto_tab 2
      map cmd+3 goto_tab 3
      map cmd+4 goto_tab 4
      map cmd+5 goto_tab 5 
      map cmd+6 goto_tab 6
      map cmd+7 goto_tab 7
      map cmd+8 goto_tab 8
      map cmd+9 goto_tab 9
      map cmd+0 goto_tab 10
    '';
  };
  xdg.configFile."kitty/light-theme.auto.conf".source =
    "${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Latte.conf";
  xdg.configFile."kitty/dark-theme.auto.conf".source =
    "${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf";
}
