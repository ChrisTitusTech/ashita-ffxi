import pefile
import sys

# Path to the executable
exe_path = "../Program Files (x86)/PlayOnline/SquareEnix/PlayOnlineViewer/pol.exe"

# Load the PE file
pe = pefile.PE(exe_path)

# LAA flag in Optional Header = 0x20
IMAGE_FILE_LARGE_ADDRESS_AWARE = 0x20

# Check if flag is already set
if pe.OPTIONAL_HEADER.DllCharacteristics & IMAGE_FILE_LARGE_ADDRESS_AWARE:
    print("LAA flag is already set.")
else:
    # Set the flag
    pe.OPTIONAL_HEADER.DllCharacteristics |= IMAGE_FILE_LARGE_ADDRESS_AWARE
    pe.write(filename=exe_path)
    print("LAA flag set successfully.")

pe.close()

