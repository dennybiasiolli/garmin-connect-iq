# GARMIN CONNECT IQ

My Garmin Connect IQ Project in one single repository


## Download apps

Download my apps from [Connect IQ Store](https://apps.garmin.com/en-US/developer/8bd344a5-7e1a-4209-a851-c099d2dff514/apps)
using [Garmin Express](https://www.garmin.com/en-US/software/express).


## Build apps on your own

Follow [Programmer's Guide](https://developer.garmin.com/connect-iq/programmers-guide/getting-started/)
to setup your Windows or Mac.


## Upload apps on Connect IQ Store

https://apps.garmin.com/en-US/developer/dashboard


## Batch compiling via command line

`sh compile-batch.sh`


## Command line guide

```sh
# Launch the simulator:
connectiq

# Compile the executable:
monkeyc -d fenix6pro \
    -f KeepCalmAndTriathlon/monkey.jungle \
    -o KeepCalmAndTriathlon.prg \
    -y $HOME/Downloads/developer_key.der

# Run in the simulator
monkeydo KeepCalmAndTriathlon.prg fenix6pro

# Compile for Publishing
monkeyc -e \
    -o KeepCalmAndTriathlon.iq \
    -w -f KeepCalmAndTriathlon/monkey.jungle \
    -y $HOME/Downloads/developer_key.der
```
