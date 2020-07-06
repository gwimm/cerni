{ config, pkgs, lib, ... }:

# this satelite mpd instance only builds a database music has to be made
# available over the network through nfs, for example

{
  services = {
    mpd = {
      enable = true;
      extraConfig = ''
        pid_file            "/run/mpd/mpd.pid"
        playlist_directory  "/var/lib/mpd/playlists"
        music_directory     "/path/to/your/music/"

        database {
            plugin           "simple"
            path             "/var/lib/mpd/mpd.db"
            cache_directory  "/var/lib/mpd/cache"
        }
      '';
    };
  };
}
