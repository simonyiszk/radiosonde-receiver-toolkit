Radiosonde receiver toolkit
===============
Collection and interoperability of different software packages for reception and decoding radiosonde signals.

### Contents:
- Radiosonde decoder plugin for SDR++
- Command-line tool for decoding telemetry packets using RTL-SDR with gpsd intergation to show real-time flight data on map
- Termux scripts for Android to support on-site balloon hunting using RTL-SDR

```
git clone --recurse-submodules https://github.com/simonyiszk/radiosonde-receiver-toolkit
cd radiosonde-receiver-toolkit
```
Radiosonde decoder plugin for SDR++
---------------
Using this [patch](https://github.com/fred-corp/sdrpp_radiosonde) based on the [original repository](https://github.com/dbdexter-dev/sdrpp_radiosonde).

![radiosondeGPX](https://user-images.githubusercontent.com/17110004/144872708-2a578c62-5493-4845-9098-9328c4e914bf.png)
Note: this tool does not support real-time tracking on map, only displays telemetry data which can be saved to gpx and csv logfiles.
### Compatibility:

| Manufacturer | Model       | GPS                | Temperature        | Humidity           | XDATA              |
|--------------|-------------|--------------------|--------------------|--------------------|--------------------|
| Vaisala      | RS41-SG     |          ✔         |          ✔         |          ✔         |          ✔         |
| Meteomodem   | M10         |                    |          ✔         |          ✔         |                    |
| Meteomodem   | M20         |          ✔         |          ✔         |                    |                    |
| GRAW         | DFM06/09/17 |          ✔         |          ✔         |                    |                    |
| Meisei       | iMS-100     |          ✔         |          ✔         |          ✔         |                    |
| Meisei       | RS-11G      |          ✔         |          ✔         |          ✔         |                    |
| InterMet     | iMet-1/4    |          ✔         |          ✔         |          ✔         |          ✔         |
| Meteolabor   | SRS-C50     |          ✔         |          ✔         |                    |                    |
| Meteo-Radiy  | MRZ-N1      |          ✔         |          ✔         |                    |                    |

### Building from source:
1. Copy the plugin folder into sources:
```
cp -r sdrpp_radiosonde SDRPlusPlus/decoder_modules
```
2. In the `SDRPlusPlus/CMakeLists.txt` file, and add the following line in the
   `# Decoders` section at the top:
```
option(OPT_BUILD_RADIOSONDE_DECODER "Build the radiosonde decoder module (no dependencies required)" ON)
```
3. In that same file, search for the second `# Decoders` section, and add the
   following lines:
```
if (OPT_BUILD_RADIOSONDE_DECODER)
add_subdirectory("decoder_modules/sdrpp_radiosonde")
endif (OPT_BUILD_RADIOSONDE_DECODER)
```
5. Build and install SDR++ following the [original guide](https://github.com/AlexandreRouma/SDRPlusPlus/blob/master/readme.md)
6. Enable the module in SDR++ by adding it via the module manager

Command-line tool with tracking support via gpsd
---------------
Displays real-time telemetry data in the terminal or in a GPS data analyzer like [Viking](https://github.com/viking-gps/viking).

### Building the RS41 decoder from source:
```
cd sonde-cli
gcc -c ../RS/demod/mod/bch_ecc_mod.c
gcc -c ../RS/demod/mod/demod_mod.c
gcc ../RS/demod/mod/rs41mod.c demod_mod.o bch_ecc_mod.o -lm -o rs41mod
cp ../RS/tools/pos2nmea.pl .
chmod +x sonde_cli.sh
chmod +x sonde_map.sh
```
For the use of other type of radiosondes, please refer to the [original repository](https://github.com/rs1729/RS/blob/master/demod/mod/README.md).

### Dependencies:
[RTL-SDR](https://github.com/osmocom/rtl-sdr) (available as submodule)
[Installation steps](https://osmocom.org/projects/rtl-sdr/wiki#Building-the-software)

### Usage:
`./sonde_cli.sh [F]` where F is the target frequency in MHz. The output will show in the terminal.

`./sonde_map.sh [F]` where F is the target frequency in MHz. In Viking, add a new GPS layer, with the default gpsd settings (Realtime tracking mode -> Autoconnect: Yes, Host: localhost, Port: 2947). The radiosonde will show up on successful telemetry reception, and will keep update the flight information on the map.

Termux scripts for Android
---------------
Coming soon

References:
===============
- https://github.com/osmocom/rtl-sdr
- https://github.com/martinmarinov/rtl_tcp_andro-
- https://github.com/termux
- https://k3xec.com/rtl-tcp/
