import pefile
pe = pefile.PE("../Program Files (x86)/PlayOnline/SquareEnix/PlayOnlineViewer/pol.exe")
print(hex(pe.OPTIONAL_HEADER.DllCharacteristics))

