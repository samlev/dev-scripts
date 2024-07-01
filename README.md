Dev Scripts
===========

Some basic scripts for making life easier when working on multiple projects with Laravel sail.

## Assumptions

The assumptions made in these scripts are:

* You use `phpstorm` as your IDE.
* You have multiple Laravel sail powered projects somewhere in your home directory.
* You have the [kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator installed.
* You have zenity installed.

If you're not me, use these at your own risk.

If you _are_ me, also use these at your own risk, but know that you should know better.

Please don't ask me for support, or tell me that I'm doing things wrong. This works for me, and that's enough.

## Installation

Install by running `install.sh` from the root of this repository. This will copy the scripts to `~/.local/bin`, add the 
configuration for kitty, and ensure that all of the required directories are created.

Run `install.sh -h` for additional options.

### Uninstallation

You can uninstall with `install.sh -U`. This will remove the scripts from `~/.local/bin`, remove all config files,
including the kitty configuration. If you installed the binaries to a different location, you can specify that with the
`-b` option, or use `-F` to attempt to delete them from where they were installed.