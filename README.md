# Ashita v4 The Tumz Config

<a href="https://github.com/AshitaXI/Ashita-v4beta">![GitHub last commit](https://img.shields.io/github/last-commit/AshitaXI/Ashita-v4beta?style=for-the-badge)</a>
<a href="https://discord.gg/Ashita">![Discord](https://img.shields.io/discord/264673946257850368?style=for-the-badge)</a>
<a href="https://github.com/AshitaXI/Ashita/issues">![GitHub issues](https://img.shields.io/github/issues/AshitaXI/Ashita?style=for-the-badge)</a>
<a href="https://github.com/AshitaXI/Ashita/issues?q=is%3Aissue+is%3Aclosed">![GitHub closed issues](https://img.shields.io/github/issues-closed/AshitaXI/Ashita?style=for-the-badge)</a>

Above is links to Official Ashita v4 repository. Current Commit, Discord, Issues Open and Closed.

## Linux Config - FFXI + Ashita v4 setup, with Lutris.

**Last updated 17 February 2025** _Credit: Wintersolstice8_

This is done on a computer running Arch Linux.

Download the FFXI setup for your region before starting this.
If you already have FFXI installed in a Wine prefix, you can obviously skip that.
EU installer
US installer
JPN installer

You obviously need to replace /placeholder/paths/like/this with your own throughout.

### Set up the Wine prefix
1) Make sure you have wine or wine-staging installed (terminal: pacman -Qs wine)
2) Open a terminal, execute:
WINEPREFIX=/path/where/you/want/ffxi winetricks corefonts win10
For example (do not copy this, it's just an example):
WINEPREFIX=/mnt/860evo/games/ffxi winetricks corefonts win10
If you're asked to install Gecko, that's fine. Do not install Mono.

### Add the prefix to Lutris
3) In Lutris click "Add game", choose "Add locally installed game".
4) Fill in the game info (use "Wine" as runner).
5) Go to "Game options", in "Executable" pick the FFXI installer.
6) In "Wine prefix", type the path you used for WINEPREFIX= in step 2. (And only the path itself!)
7) In "Prefix architecture", pick 64-bit.
8) go to "Runner options", set "Wine version" to "System".
9) Leave DXVK enabled.
10) Probably won't matter, but disable VkD3D, D3D Extras, DXVK-NVAPI, and dgVoodoo2.
11) Disable fsync.
12) Save.

### Installing FFXI & Ashita v4
13) Run the game through Lutris, fully install FFXI before moving on.
(Remember, in step 5 you should have set the game's installer as your executable. That's what you're starting here.)

14) Once FFXI is installed, use Winetricks to install these dependencies for Ashita: gdiplus dotnet48 vcrun2022
Example: WINEPREFIX=/path/to/ffxi/prefix winetricks gdiplus dotnet48 vcrun2022 win10

15) Using a terminal, execute cd /path/to/ffxi/prefix ("cd" is the "change directory" command)
16) Execute cd drive_c
17) Execute git clone https://github.com/AshitaXI/Ashita-v4beta.git
18) Now configure Ashita as per the Ashita v4 documentation, found at https://docs.ashitaxi.com/usage/configurations/
19) Now is a good time to install winefix by atom0s.

Join the Ashita Discord to download it, or from my Mega mirror
At the time of writing that's the latest version, downloaded here (Discord link)
Add it to your profile's .ini file. (/load winefix)

### Installing a full version of dgVoodoo 2 to prevent crashes.
20) Download dgvoodoo2 2.8.2 - I have mirrored it here: https://mega.nz/file/Z55T3TIK#XS1VC7YAIUReri5fhY0v41YsN-GdlrJBxSoOyC66pPE
21) Extract everything to the PlayOnlineViewer directory (where pol.exe is, NOT the FINAL FANTASY XI directory).
22) Click FFXI in Lutris, and then the Wine glass icon on the bottom menu bar.
23) Click "Wine configuration", move to the "Libraries" tab.
24) In "New override for library:", add overrides for these one by one, including the asterisk:

*d3d8, *d3dimm, *ddraw (Accept any warnings)

25) Run "dgVoodooCpl.exe" in your FFXI Wine prefix, and configure the DirectX tab to your liking.

(Hint: In dgVoodooCpl, be certain that "Config folder / running instance" points to your PlayOnlineViewer directory.)
(Hint 2: In Lutris, click the Wine glass icon, then "Run EXE inside Wine prefix".)
(Hint 3: I just set VRAM to 1024MB and remove the dgVoodoo Watermark. Nothing else. Adjust to your hardware accordingly.)

### Reconfiguring the game in Lutris to launch Ashita.
26) Right click FFXI in Lutris and set the executable to where you downloaded ashita-cli.exe instead.
27) In "Arguments", type in the name of your profile's .ini file.
28) In "Working directory", type in the path to the directory you have ashita-cli.exe in.
29) Save.

Bob's your uncle!
While you're here, consider the following patch to improve the stability of the game.

### Tweak: Patching pol.exe to be large address aware.
Recommended, but you may skip this step especially if you don't intend to use high-res texture mods.
1) Download Thorny's Large Address Aware patcher from https://github.com/ThornyFFXI/LargeAddressAware/releases/latest
2) Unpack it anywhere, somewhere in the Wine prefix makes it easier for you.
3) Make a backup of pol.exe.
4) Open LargeAddressAwarePatcher.exe using Wine. WINEPREFIX=/path/to/ffxi wine LargeAddressAwarePatcher.exe
5) Select pol.exe and click patch.
