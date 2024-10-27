# Lattice iCE40 FPGA Template Files

This repository stores the needed files to get started with the iCE40 line of FPGAs from Lattice.

## Getting Started

### Build tools

There are two approaches for build tools: official tools for Lattice or open-source tools. This document uses the official tools on a Windows PC.

1. Download and install `Lattice iCEcube2` IDE from [website](https://www.latticesemi.com/Products/DesignSoftwareAndIP/FPGAandLDS/iCEcube2). You'll need to make an account.
2. Get a license for the dev tools. You will need to email Lattice to request the free license. This may take a few days.
3. Use the `LicenseSetup.exe` tool to add the license to your system.
4. Download the `Lattice Diamond Programmer` and install it. Go [here](http://www.latticesemi.com/latticediamond) and scroll down to `Programmer Standalone 3.14 64-bit for Windows` and install.

### Creating iCEcube2 Example Project

Make sure you have the [iCEstick hardware development board](https://www.latticesemi.com/icestick)! This is available across the internet for around $30-40.

1. Download this repo to your PC.
2. Open iCEcube2 IDE
3. Create a new project targetting the [FPGA device on the iCEstick hardware](https://www.digikey.com/product-detail/en/lattice-semiconductor-corporation/ICE40HX1K-TQ144/220-1565-ND/3083575):
    1. Set project name: `test1`
    2. Set the directory to this repo
    3. Set device family: `iCE40`
    4. Set device: `HX1K`
    5. Set device package: `TQ144`
    6. Ensure junction temp range is `Commercial`
    7. Ensure core voltage torerance is +/-5% at 1.2V 
    8. Set all I/O bank voltages to 3.3
    9. Ensure timing analysis is based on `Worst` values
    10. Ensure `Start from Synthesis` is selected
4. Add the following files to the project:
    1. `top.v`, `sys.v`, `pll.v`
    2. `constraints.sdc`
    3. `pins.pcf`

### Generate Bitmap

1. In iCEcube2, click `Tool` > `Run All`

This kicks off the tool chain to generate the bitmap. It will synthesize and place & route the design. Upon success of each step, a green check mark should appear in the left window pane. Once `Generate Bitmap` has a green check mark, the process is done. It should take <10 seconds.

Note that the compilation process generates A LOT of information! This info is useful for many reasons, such as determining if the design meets timing requirements and seeing FPGA device resource utilization.

You may now close iCEcube2 IDE, we no longer need it.

### Programming iCEstick Hardware

We now have the required bitmap to program into the flash of the iCEstick hardware.

1. Plug in the iCEstick to your PC
2. Open `Diamond Programmer`
3. Click `Detect Cable` and select your device
4. Select `Create a new blank project` and click `OK`
5. Under `Device Family` column, change `Generic JTAG Device` to `iCE40`
6. Under `Device` column, change to `iCE40HX1K`
7. Double-click on `Fast Program` in the `Operation` column to configure:
    1. Change access mode to `SPI Flash Programming`
    2. Select the bitmap `.bin` file generated from iCEcube2 (usually located at `$REPO_ROOT/test1/test1_Implmnt/sbt/outputs/bitmap/top_bitmap.bin`)
    3. Set SPI Flash Family: `SPI Serial Flash`
    4. Set SPI Flash Vendor: `Micron`
    5. Set SPI Flash Device: `N25Q032`
    6. Set SPI Flash Package: `8-pin VDFPN8`
    7. Click `Load from File`
    8. `OK`
8. Click `Design` > `Program`
 
This will send the bitmap binary contents over USB to the iCEstick and store them in the SPI flash device.

**Congratulations!** Your FPGA should be running and the LEDs should be blinking!


## Notes

### Global Signals (`clk` and `rst_n`)

The template files configure the FPGA PLL to accept the 12MHz clock input `CLK_IN` from the oscillator on the PCB and derive a 120MHz clock `clk` which is used for the rest of the digital logic. They also provide a global, asynchronous, active-low reset signal `rst_n` which can be used to set initial values for registers.

### Configuring `clk` Frequency

You can adjust the PLL settings to use a different system clock frequency by editing `pll.v`. To generate the correct PLL settings, use the iCEcube2 PLL configuration tool: `Tool` > `Configure ...` > `Configure PLL Module ...`. This wizard can be used to generate the right `DIV*` constants for various frequencies.
