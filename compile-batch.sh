MONKEYC=~/Library/Application\ Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-4.0.5-2021-08-10-29788b0dc/bin/monkeyc
CERTIFICATE=~/Downloads/developer_key.der

$MONKEYC -e \
    -o out/Analog24hour.iq \
    -w -f Analog24hour/monkey.jungle \
    -y $CERTIFICATE
monkeyc -e \
    -o out/AnalogDigital.iq \
    -w -f AnalogDigital/monkey.jungle \
    -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndDuathlon.iq \
    -w -f KeepCalmAndDuathlon/monkey.jungle \
    -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndRideBike.iq \
    -w -f KeepCalmAndRideBike/monkey.jungle \
    -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndRun.iq \
    -w -f KeepCalmAndRun/monkey.jungle \
    -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndSwim.iq \
    -w -f KeepCalmAndSwim/monkey.jungle \
    -y $CERTIFICATE
monkeyc -e \
    -o out/KeepCalmAndTriathlon.iq \
    -w -f KeepCalmAndTriathlon/monkey.jungle \
    -y $CERTIFICATE
