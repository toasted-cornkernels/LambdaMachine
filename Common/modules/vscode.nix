{
  config,
  lib,
  pkgs,
  lambdaMachineDir,
  ...
}:

# VS Code's user config lives in ExternalConfigs/dots/vscode, which is public.
# keybindings.json is a plain symlink. settings.json can't be one, since work
# settings (proxies, internal hosts) must stay out of git: on each switch the
# untracked ~/.config/vscode/settings.private.jsonc is appended to the tracked
# base. VS Code has no settings include, hence the concatenation.
let
  dots = "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/vscode";
  userDir = "${config.home.homeDirectory}/Library/Application Support/Code/User";
  stateDir = "${config.xdg.stateHome}/vscode";
  sha256 = "${pkgs.coreutils}/bin/sha256sum";
in
{
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dots}/keybindings.json";

  home.activation.vscodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    base="${dots}/settings.json"
    private="${config.xdg.configHome}/vscode/settings.private.jsonc"
    target="${userDir}/settings.json"
    merged="${stateDir}/settings.merged.json"
    stamp="${stateDir}/settings.sha256"

    if [ -f "$base" ]; then
      run mkdir -p "${stateDir}" "${userDir}"
      # Both files are JSONC objects whose final line is `}`. Splice the private
      # object's body before the base's closing brace; VS Code allows the
      # trailing commas this leaves.
      {
        sed '$d' "$base" | sed '$ s/\([^,{]\)[[:space:]]*$/\1,/'
        if [ -f "$private" ]; then
          sed -n '/^{/,/^}/p' "$private" | sed '1d;$d'
        fi
        echo '}'
      } > "$merged"

      if [ -f "$target" ] && [ -f "$stamp" ] \
         && [ "$(${sha256} < "$target")" != "$(cat "$stamp")" ]; then
        warnEcho "VS Code settings.json was edited since the last switch; not overwriting it."
        warnEcho "Port the changes to $base (or $private), then delete $stamp."
        warnEcho "Compare with: diff \"$merged\" \"$target\""
      elif ! cmp -s "$merged" "$target"; then
        if [ -f "$target" ] && [ ! -f "$stamp" ]; then
          run cp "$target" "$target.before-home-manager"
        fi
        run cp "$merged" "$target"
        run sh -c '${sha256} < "$1" > "$2"' _ "$target" "$stamp"
      elif [ ! -f "$stamp" ]; then
        run sh -c '${sha256} < "$1" > "$2"' _ "$target" "$stamp"
      fi
    fi
  '';

  # Nix is the source of truth, so Settings Sync must stay off: it needs a
  # GitHub sign-in and would upload the private settings. VS Code has no policy
  # for it, so flip the flag in its state database.
  home.activation.vscodeSettingsSyncOff = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    db="${userDir}/globalStorage/state.vscdb"
    if [ -f "$db" ] && [ "$(${pkgs.sqlite}/bin/sqlite3 "$db" \
         "SELECT value FROM ItemTable WHERE key = 'sync.enable'")" = "true" ]; then
      run ${pkgs.sqlite}/bin/sqlite3 "$db" \
        "UPDATE ItemTable SET value = 'false' WHERE key = 'sync.enable'"
      warnEcho "Turned off VS Code Settings Sync. Restart VS Code if it is running."
    fi
  '';
}
