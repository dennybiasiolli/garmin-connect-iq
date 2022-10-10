#!/bin/bash

MONKEYC_BIN=~/Library/Application\ Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-4.1.5-2022-08-03-6e17bf167/bin
CERTIFICATE=~/Downloads/developer_key.der

PATH=$MONKEYC_BIN:$PATH

## Remove the System 5 preview devices from your app before you build the .iq file.

monkeyc -e \
    -o out/Analog24hour.iq \
    -w -f Analog24hour/monkey.jungle \
    -r -y $CERTIFICATE
monkeyc -e \
    -o out/AnalogDigital.iq \
    -w -f AnalogDigital/monkey.jungle \
    -r -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndDuathlon.iq \
    -w -f KeepCalmAndDuathlon/monkey.jungle \
    -r -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndRideBike.iq \
    -w -f KeepCalmAndRideBike/monkey.jungle \
    -r -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndRun.iq \
    -w -f KeepCalmAndRun/monkey.jungle \
    -r -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndSwim.iq \
    -w -f KeepCalmAndSwim/monkey.jungle \
    -r -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndTriathlon.iq \
    -w -f KeepCalmAndTriathlon/monkey.jungle \
    -r -y $CERTIFICATE
