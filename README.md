This project tests a PR that allows SPI by Full Duplex Communication (with
IOCTL) by OpenHSP.
https://github.com/RollMan/OpenHSP/tree/spi

## Test cl version
Suppose you have binaries and necessary files in the parent directory (`hsp3dish`, `hspcmp`, `common/`, `ipaexg.ttf`).

```
../hspcmp --compath=$HOME/common/ -oa.ax -i -u -d ./spitest_mcp3008_cl.hsp
../hsp3cl a.ax
```


## Test dish version
Suppose you have binaries and necessary files in the parent directory (`hsp3dish`, `hspcmp`, `common/`, `ipaexg.ttf`).

```
../hspcmp --compath=$HOME/common/ -oa.ax -i -u -d ./spitest_mcp3008_dish.hsp
../hsp3dish ./a.ax
```
