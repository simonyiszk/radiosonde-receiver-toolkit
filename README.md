Radiosonde receiver toolkit
===============
Collection and interoperability of different software packages for reception and decoding radiosonde signals.

### Contents:
- Radiosonde decoder plugin for SDR++
- Command-line tool for decoding telemetry packets using RTL-SDR with gpsd intergation to show real-time flight data on map
- Termux scripts for Android to support on-site balloon hunting using RTL-SDR

Radiosonde decoder plugin for SDR++
---------------
Using this [patch](https://github.com/fred-corp/sdrpp_radiosonde) based on the [original repository](https://github.com/dbdexter-dev/sdrpp_radiosonde).

![radiosondeGPX](https://user-images.githubusercontent.com/17110004/144872708-2a578c62-5493-4845-9098-9328c4e914bf.png)

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
1. Add the plugin to sources:
```cp -r sdrpp_radiosonde SDRPlusPlus/decoder_modules```

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
5. Build and install SDR++ following the [original guide](SDRPlusPlus/readme.md)

6. Enable the module by adding it via the module manager

Command-line tool
---------------
Coming soon

Termux scripts for Android
---------------
Coming soon

References:
===============
- https://github.com/osmocom/rtl-sdr
- https://github.com/martinmarinov/rtl_tcp_andro-
- https://github.com/termux
- https://k3xec.com/rtl-tcp/
