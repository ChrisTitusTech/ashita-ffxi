# Packer
Packer is a plugin designed to make rearranging your gear for job changes quick and easy.<br>
It can fetch items from an ashitacast XML, or simply organize your inventory based on it's own configuration file.<br>
<br>
### Commands
All commands can be prefixed with **/pa** or **/packer**.<br>
Any parameter that includes a space must be enclosed in quotation marks(**"**).

**/pa validate [required: Ashitacast XML Name]** or **/ac validate**(requires Ashitacast)<br>
Validate will parse the sets section of an ashitacast XML and list which items the XML lists that you do not currently have in equippable bags.<br>
This does not include any items in other parts of the XML, or include tags.  If you trigger validate through ashitacast, include tags will be honored.<br>
Items that are only listed in the body of your ashitacast XML should be also listed in a packer section in sets.  See ashitacast documentation.<br>

**/pa gear [required: Ashitacast XML Name]** or **/ac gear**(requires Ashitacast)<br>
Gear will automatically collect the gear listed in an ashitacast XML while also keeping your inventory organized according to your packer config.<br>
The same rules as validate apply.

**/pa organize**<br>
This will organize your gear in accordance with your configuration file.  It will not specifically gather any gear for your current job.<br>

**/pa stop**<br>
This will stop a gear or organize event immediately.

**/pa load [Optional: Packer Config XML Name]**<br>
This will load a specific packer config XML.  If none is specified, the default file will be loaded.<br>
The default config XML must be located at Ashita/config/packer/charname.xml or Ashita/config/packer/default.xml.<br>
If a character specific config exists, it will be loaded instead of the default config.  If no default config exists, packer will make it on initial load.