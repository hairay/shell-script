#!/bin/sh

export ETHERNET_BIT=0x00000040
export ETHERNET_PIOSET=0x0400A0C0
export ETHERNET_PIORES=0x0400A0E0
export ETHERNET_PIODIR=0x0400A040

export READY_BIT=0x00008000
export READY_PIOSET=0x0400A0C0
export READY_PIORES=0x0400A0E0
export READY_PIODIR=0x0400A040

export ERROR_BIT=0x40000000
export ERROR_PIOSET=0x0540D0C0
export ERROR_PIORES=0x0540D0E0
export ERROR_PIODIR=0x0540D040

ClearRegBitPos() {
        reg=$(busybox devmem $1 32)
        reg=$((reg & ~$2))
        busybox devmem $1 32 $reg
}

O_LED_init() {
        busybox devmem $ETHERNET_PIORES 32 $ETHERNET_BIT
        ClearRegBitPos $ETHERNET_PIODIR $ETHERNET_BIT

        busybox devmem $READY_PIOSET 32 $READY_BIT
        ClearRegBitPos $READY_PIODIR $READY_BIT

        busybox devmem $ERROR_PIORES 32 $ERROR_BIT
        ClearRegBitPos $ERROR_PIODIR $ERROR_BIT
}

LEDSwitchOn() {
	busybox devmem $ETHERNET_PIOSET 32 $ETHERNET_BIT
	busybox devmem $READY_PIOSET 32 $READY_BIT
	busybox devmem $ERROR_PIOSET 32 $ERROR_BIT
}

LEDSwitchOff() {
	busybox devmem $ETHERNET_PIORES 32 $ETHERNET_BIT
	busybox devmem $READY_PIORES 32 $READY_BIT
	busybox devmem $ERROR_PIORES 32 $ERROR_BIT
}

O_LED_init
while true
do
    LEDSwitchOn
    sleep 1
	LEDSwitchOff
	sleep 1
done
