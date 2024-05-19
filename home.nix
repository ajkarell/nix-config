{ config, pkgs, users, ... }:
{
  home-manager = {
    users =
      {
        "nixos" =
          {
            # Home Manager needs a bit of information about you and the paths it should
            # manage.
            home.username = "nixos";
            home.homeDirectory = "/home/nixos";

            # The home.packages option allows you to install Nix packages into your
            # environment.
            home.packages = with pkgs; [
            ];

            programs.git = {
              enable = true;
              userName = "ajkarell";
              userEmail = "111962031+ajkarell@users.noreply.github.com";
              aliases = {
                coa = "!git add -A && git commit -m";
                l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
                acoa = "!git add -A && git commit --amend --no-edit --reset-author";
                acoam = "!git add -A && git commit --amend --no-edit --reset-author -m";
                p = "push";
                pf = "push --force-with-lease";
              };
            };

            # Home Manager is pretty good at managing dotfiles. The primary way to manage
            # plain files is through 'home.file'.
            home.file = { };

            home.sessionVariables = {
              # EDITOR = "emacs";
            };

            # Let Home Manager install and manage itself.
            programs.home-manager.enable = true;

            # This value determines the Home Manager release that your configuration is
            # compatible with. This helps avoid breakage when a new Home Manager release
            # introduces backwards incompatible changes.
            #
            # You should not change this value, even if you update Home Manager. If you do
            # want to update the value, then make sure to first check the Home Manager
            # release notes.
            home.stateVersion = "23.11"; # Please read the comment before changing.
          };
      };
  };
}
