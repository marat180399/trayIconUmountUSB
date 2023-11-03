#!/usr/bin/python 
# This python script runs icon in tray

import pystray
import PIL.Image
import pyudev
import re
import subprocess
import time

time.sleep(0.5)
# Image path
image = PIL.Image.open("/home/user/tray/usb-drive.png")
# Reading context of all udev defined devices
context = pyudev.Context()
# Pattern for sd or sr devices
pattern = r"^(/dev/sd|/dev/sr)"
# Clear array for future menu items
menu_items = []

def on_clicked(icon, item):
    for device in context.list_devices(subsystem='block', DEVTYPE='partition'):
        if str(device.get('ID_VENDOR'))==str(item):
            # Umount command
            subprocess.run(["umount", device.get('DEVNAME')])

# For each device that is accepts to a pattern, add Menu item
for device in context.list_devices(subsystem='block', DEVTYPE='partition'):
    if re.search(pattern, device.get('DEVNAME')):
        # Get 'ID_VENDOR' value or set 'unlabeled partition' if value is not defined
        device_name = device.get('ID_VENDOR', 'unlabeled partition')
        # Create menu item
        menu_items.append(pystray.MenuItem(device_name, on_clicked))

# Initialize icon in tray
icon = pystray.Icon("usb", image, menu=pystray.Menu(*menu_items))
# Run icon in tray
icon.run()
