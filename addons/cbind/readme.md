# cBind
This addon allows you to bind controller buttons to ingame commands.  This can be done via typed commands or by using the GUI.

# Commands

* /cbind<br>
This opens the GUI.  You should do this first upon loading the addon, and select the type of controller you are using.  All XInput controllers use a standardized API, so the xinput mapping will work for all of them.  If your controller does not have standard button labels, it is possible some may be mismatched.  You can use the debug mode to figure out what binding to use for any button if this is the case.  Directinput controllers are much more variable, because the spec does not require the controller to adhere to any strict layout.  Profiles are included for Dualsense, Switch Pro Controller, and Stadia.  If you have a different controller and need assistance with it, contact me via the Ashita discord.  Expect that it may take up to an hour with your active participation to create a new mapping for a controller I do not own.

* /cbind debug<br>
Toggles debug mode.  When debug mode is enabled, any recognized button presses will be output to the log with the name they are recognized as.  This can be used for identifying how to bind unknown buttons or verifying the addon is working as intended with your controller.

* /cbind [Button Name] [Optional: up/down] [Command]<br>
Binds a command to a button.  If you do not specify up/down, the bind will trigger when the button is pressed down.  If you specify up, it will trigger when the button is released.  Binds to release do not prevent the game from seeing the button, while binds to press do.

* /cunbind [Button Name] [Optional: up/down]<br>
This clears a bind.

# Bound Commands
Commands can include standard ASCII characters except semicolons.  Semicolons delineate commands, allowing you to use multiple commands from the same bind.  Both /wait and `<wait>` notation are supported.  For example, you can do:<br>
`/cbind R2 /p Opening SC in 10 seconds..;/wait 7;/p Opening SC in 3 seconds <wait 3>;/ws "Savage Blade" <t>`