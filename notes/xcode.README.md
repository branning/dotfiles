## SwiftLint integration for XCode

https://github.com/norio-nomura/SwiftLintForXcode

## Get list of known devices with UUIDs

instruments -s devices | grep -v Simulator

# Use wireshark to inspect Wi-Fi traffic to device

You can attach a device to a Mac by a USB cable and then run all of its network
traffic through the cable, and inspect the packets with libpcap (tcpdump and
Wireshark).

This is done with a Remote Virtual Interface (RVI).

# Create an RVI

rvictl -s 951363b666e155206b529cd7773f5985b101a7bb

# Delete an RVI

rvictl -x 951363b666e155206b529cd7773f5985b101a7bb



