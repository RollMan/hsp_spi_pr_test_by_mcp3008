; ADC Library by MCP3008 via SPI on Raspberry Pi
#ifndef __mcp3008_as__
#define __mcp3008_as__

#include "hsp3cl.as"

#module
; adcget
; ------
; Read an analog input from an ADC chip supposed to be MCP3008.
; Open an SPI channel in advance by:
; 	devcontrol "spiopen" <spidev_idx>, <fd_ch>
;
; Parameters
; ----------
; _p1: int
; 	Pin number of MCP3008 from which you are to read voltage.
; 	MCP3008 has 8 channels so 0 <= _p2 < 8.
; _p2: int
; 	Index where the file descriptor is saved.
;
; Returns
; -------
; analog_input: int
; 	Normalized voltage value corresponding to the pin as a range of 0--1023.
#defcfunc adcget int _p1, int _p2
	adc_pin = _p1
	ch = _p2

	devcontrol "spiopen", devname_idx, ch
	if stat: return -1

	; Configure spidev options
	devcontrol "spisetmaxspeedhz", 10000, ch
	if stat: return -2
	devcontrol "spisetmode", 0, ch
	if stat: return -3
	devcontrol "spisetlsbfirst", 0, ch
	if stat: return -4
	devcontrol "spisetbitsperword", 8, ch
	if stat: return -5
	devcontrol "spiconfigureh", 10000, 0, 8
	if stat: return -6
	devcontrol "spiconfigurem", 1, 0, 0	; Keep selecting the device for the 3-bytes command
	if stat: return -7
	devcontrol "spiconfigurel", 0
	if stat: return -8

	; Start communication
	;; Prepare a buffer as {dont care, upper 2 bits of data, lower 8 bits of data}
	dim recv, 3
	;; Send start byte
	devcontrol "spitransceive", 1, ch
	if stat < 0: return -9
	byte(0) = stat
	;; Send control byte: SINGLE_ENDED (0x80) | adc_pin.
	;; In bit-wire sepresentation, {single/diff, adc_pin[2], adc_pin[1], adc_pin[0], x, x, x}
	SIGNLE_ENDED = 0x80
	devcontrol "spitransceive", SINGLE_ENDED | (adc_pin << 4), ch
	if stat < 0: return -10
	byte(1) = stat
	;; Send an empty byte (avoiding start byte 0x01) and receive rest data.
	devcontrol "spiconfigurem", 0, 0, 0	; Deselect the device
	if stat < 0: return -11
	devcontrol "spitransceive", 0x00, ch
	if stat < 0: return -12
	byte(2) = stat

	res = ((0x03 & byte(1)) << 8) | byte(2)
	return res
#global
#endif
