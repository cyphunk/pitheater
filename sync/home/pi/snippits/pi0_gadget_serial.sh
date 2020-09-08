#!/bin/bash
# add at startup to enable serial over USB OTG
# for pi zero only
#
# src: PiBakery

# Add the line to /boot/config.txt if it's not already there
if ! grep -qxF "dtoverlay=dwc2" "/boot/config.txt"
then
  echo "dtoverlay=dwc2" | tee -a /boot/config.txt
fi

# Add the line to /etc/modules if it's not already there
if ! grep -qxF "dwc2" "/etc/modules"
then
  echo "dwc2" | tee -a /etc/modules
fi

# Remove any modules currently in /etc/modules
otg_modules=( "g_serial" "g_ether" "g_mass_storage" "g_midi" "g_audio" "g_hid" "g_acm_ms" "g_cdc" "g_multi" "g_webcam" "g_printer" "g_zero" )
for module in "${otg_modules[@]}"
do
  if grep -qxF "$module" "/etc/modules"
  then
    grep -v "$module" "/etc/modules" > "/etc/modules2"; mv "/etc/modules2" "/etc/modules"
  fi
done

# Add g_serial to /etc/modules
echo "g_serial" | tee -a /etc/modules

# Forward a console over the serial
systemctl enable getty@ttyGS0.service
