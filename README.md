# Reactor Controller

For ComputerCraft (& Advanced Peripherals) & Mekanism , featuring web server and client capability.

----------

## Installation

Pastebin code for `updater.lua`, which is used to download/update all files under the `/src/lua` directory, is below:

```pastebin get h7Y1L2NP updater.lua```

**Note**: Place the `updater.lua` file in the folder;

- `/server`, if installing for a "peripheral data server"
- `/reactor`, if installing for the main computer (the one with GUI output)

For a peripheral data server, you must first run `configureserver.lua`, provided you've already run `updater.lua` and acquired all the files.
For the main computer, you may want to create a `startup.lua` file in the root directory containing the code `shell.run("/reactor/main.lua")`

----------

## TODO?

- Protected website for reactor controls and dashboard
- Auto-controls for reactor? (safety?)
- Improve readme and documentation
