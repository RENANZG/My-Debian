> **WARNING:** BIOS modding can be dangerous. You run the risk of *bricking your device*. I am not responsible for broken devices.

> This tutorial was created for my HP Pavilion 15 laptop. I *cannot confirm* that this works on any other devices.

***

## Finding variable
We need to find the offset, varstore, and possible values for the DVMT pre-alloc.

### Extracting BIOS
1. Download the BIOS updater from your manufacture's website.
2. Run the updater. Look for an option to extract the update file.
3. Extract the bin file.

### Extracting config section
1. Open your bin file in [UEFITool](https://github.com/LongSoft/UEFITool/releases).
2. Search for the string "DVMT" in UEFITool.
3. It should highlight a section named "Setup" or similar. (Or not, mine was named something else.)
4. Right-click and extract it as a bin or sct file.

### Extracting IFR text
1. Using [IFR Extractor](https://github.com/LongSoft/Universal-IFR-Extractor/releases), extract the bin or sct file to a txt file.

### Finding variable
1. Open the text file in an editor and search for "DVMT".
2. Look for the offset and the value corresponding to your desired option. Take the varstore id and go to the table in the beginning, looking up it's name.

***

If you got the offset value, you can download RU.

You can find it here: http://ruexe.blogspot.com/

Don't try to use the exe file, it's for DOS, not Windows. What we need is the RU.efi file.

Now, follow these steps:

1. Grab an USB drive, 100 mb is enough but it needs to be empty.

2. Format it as MBR, fat32. You can use Rufus on Windows, or Disk Utility on macOS.
    > Note: GPT works too but you'll need an EFI partition on your drive for it.

3. You now have an empty USB drive. Create a folder called "EFI" and in that folder, create another folder called "BOOT". In "BOOT", paste RU.efi and rename it to bootx64.efi. The file tree should thus look like this:
     
    ![Tree](https://user-images.githubusercontent.com/53275876/132030535-46bd4fca-f1d7-4879-8c48-bf0c6e6085a1.png)
    
    > On GPT, this would be in the hidden EFI folder, and then pasted in the (normally) already present BOOT folder. You can also temporarily use your OpenCore/Clover boot USB since those already have the EFI partition. Just replace the bootx64.efi with RU.efi and also rename it. After we're done, you can place the old bootx64.efi back. This method is possible but I wouldn't recommend it.

4. Make sure secure boot is disabled in your BIOS and boot to the USB drive. You'll be greeted with a screen like this.
    
    ![Start](https://user-images.githubusercontent.com/53275876/132030840-daff26d6-670a-4ce3-a1f4-b453788dc80c.jpg)
    
    Just press enter. Now, we'll go to a screen to edit UEFI variables. Press <kbd>alt</kbd> + <kbd>=</kbd>. You should get a screen like this.
    
    ![UEFI_Variables](https://user-images.githubusercontent.com/53275876/132030991-e232f108-ce64-4f5a-9785-fef6acc8bef9.jpg)
    
    > Note: You can navigate in the tool by using the bar at the top. Press <kbd>alt</kbd> + First letter of a word in the bar to go to there. For example, by pressing <kbd>alt</kbd> + <kbd>C</kbd>, you'll go to the "CONFIG" tab. Press <kbd>f1</kbd> to know more about key shortcuts.

5. Now, search the list till you find "CPUSetup".
    
    ![UEFI_Variables_2](https://user-images.githubusercontent.com/53275876/132031456-98d96d49-87b3-4435-ab5a-0f601e1fdcbd.jpg)
    
    Press <kbd>enter</kbd>.

6. If everything's right, you should get a screen that looks like this.
    
    ![OFFSET_BEFORE](https://user-images.githubusercontent.com/53275876/132031696-8232353e-beb7-44bf-a3c9-da70c59d1815.jpg)
    
    Now, remember the value from the dortania guide? We'll need that here. For example, my offset value is `0x3C`. Finding that value is easy. In my example, `0030` is for the `3`, and `0C` is for the `C`. In the upper left corner you should be able to comfirm it's the right value. For me, it's displayed as `003C`.
    
    > Note: if you can’t find your value, chances are it’s on a different page. You can scroll through the pages with <kbd>ctrl</kbd> + <kbd>pg up</kbd>/<kbd>pg down</kbd>
    
    As you can see, the value set is `01`. Set that to whatever value you got from above, that corresponds with the desired DVMT value. Again, `0x3C` is for my pc specific, yours will probably be different. So press <kbd>enter</kbd>, and just type it (numlock might be enabled, be aware of that). If everything goes right, that value should be highlighted now.
    
    ![OFFSET_EDITING](https://user-images.githubusercontent.com/53275876/132032193-4e411771-dfc6-4eca-8112-2f3561dc366a.jpg)
    
    Press again <kbd>enter</kbd> to finish the editing.
    
    ![OFFSET_AFTER](https://user-images.githubusercontent.com/53275876/132032317-6fc2b414-2b95-4a46-8f9b-1d85e516ea61.jpg)

7. Press <kbd>ctrl</kbd> + <kbd>W</kbd> to save. Press <kbd>alt</kbd> + <kbd>Q</kbd> to quit and turn the computer off. Done!

The DVMT value should be modifed now. Not sure how to verify it, other than trying to boot macOS and seeing if it works. Be aware that resetting your BIOS will also reset the DVMT configuration, and you will need to do this over again. So, it can be handy to write that value down somewhere. Also, note that this value may change with BIOS updates.

If something isn’t clear, leave a comment.

Sources:
 + https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html#turning-off-cfg-lock-manually
 + https://www.reddit.com/r/hackintosh/comments/hz2rtm/cfg_lockunlocking_alternative_method/