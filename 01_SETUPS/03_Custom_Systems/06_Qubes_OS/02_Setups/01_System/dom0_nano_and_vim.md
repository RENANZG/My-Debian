Custom command in Thunar (GUI) that allows to open a plain text document with either nano or vim:

1. Open Thunar.
2. Right-click on the text file you want to open.
3. Select "Open With" and then choose "Other Application...".
4. In the dialog that appears, look for the option that says "Use a custom command".
5. Enter the following command:


exo-open --lauch TerminalEmulator -- nano %f


Also you could go to the "Edit" menu and select "Configure custom actions".

References:

https://askubuntu.com/questions/891680/xubuntu-thunar-open-terminal-here-opens-konsole-in-homefolder