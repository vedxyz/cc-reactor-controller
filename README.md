# Reactor Controller

For ComputerCraft (& Advanced Peripherals) & Mekanism, ~~featuring web server and client capability~~ _maybe later_.

There is however, a pastebin-like Node.js server implementation which was immensely helpful during the development process.

![Screenshot of Main Computer](https://i.imgur.com/xTBcP4F.png)
Interacting with the monitor (right-clicking) is possible. You can scroll through and switch to tabs. Reactor tabs will have the options seen above, for changing the state and burn rate. When trying to set the burn rate, the computer will open a prompt for you to input the new burn rate value (which means you need to open the computer's GUI for this).

![Screenshot of Peripheral Data Server](https://i.imgur.com/einCRkM.png)

----------

## Computer Setup

Main computer has a 3x3 advanced monitor connected to it, along with an ender modem.

Peripheral data servers also have an ender modem, but are connected to an induction matrix / fission reactor / turbine using a **peripheral proxy** from Advanced Peripherals.

----------

## Installation

Pastebin code for `updater.lua`, which is used to download/update all files under the `/src/lua` directory, is below:

```pastebin get h7Y1L2NP updater.lua```

**Note**: Place the `updater.lua` file in the folder;

- `/server`, if installing for a "peripheral data server"
- `/reactor`, if installing for the main computer (the one with GUI output)

For a peripheral data server, you must first run `configureserver.lua`, provided you've already run `updater.lua` and acquired all the files.

For the main computer, you may want to create a `startup.lua` file in the root directory containing the code `shell.run("/reactor/main.lua")`. Alternatively, run `configuremain.lua` to set a static number of connected structures and create a `startup.lua` file. (Setting a static number of connected structures helps with startup times)

----------

## TODO?

- Protected website for reactor controls and dashboard
- Auto-controls for reactor? (safety?)
- Improve readme and documentation
  - Add a section briefly outlining the architecture of the lua scripts?
