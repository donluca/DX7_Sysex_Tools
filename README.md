# DX7 Sysex Tools
A collection of (bad) Bash scripts to manage big DX7 Sysex collections  

# WARNING
I wrote those tools mainly for myself while I was working on a curated sysex library for [Minidexed](https://github.com/probonopd/MiniDexed) and they are unpolished, probably broken in some ways or others and, fundamentally, just plain bad.  
If you need proper tools, I urge you to consider the excellent [MDX_Tools by BobanSpasic](https://github.com/BobanSpasic/MDX_Tool/) which were, to some degree, inspired by the work done on the aforementioned library and the absolute disaster of my own tools.  
If you still insist on using those tools, read on...

# The order on how those tools should be used
You have a big library of sysex files you need to manage, most likely because you downloaded it from the Internet and it's full of duplicates, broken banks and whatnot, so you need to clean the mess up and re-organize it.  
This is the order of how those tools should be used:  

1. Download those tools in a directory, either by downloading as ZIP or `git clone https://github.com/donluca/DX7_Sysex_Tools`
2. Put the folder with your sysex library inside the folder that has those tools *(first big red flag)*
3. Open a terminal and navigate to the script's folder
4. Make sure that there are no spaces in filenames or directory names. You can run something like this to replace spaces with underscores: `find . -name "* *" | awk '{ print length, $0 }' | sort -nr -s | cut -d" " -f2- | while read f; do base=$(basename "$f"); newbase="${base// /_}"; mv "$(dirname "$f")/$(basename "$f")" "$(dirname "$f")/$newbase"; done` *(second big red flag)*
5. As this tool only works with headerless files *(third big red flag)*, you'll have to first use [Boban's MDX_Tools](https://github.com/BobanSpasic/MDX_Tool/) to make sure that all sysex files have headers by running something like `find . -iname "*.syx" -execdir MDX_Tool -r -f {} \;` and then `find . -type f -iname "*repaired*" -execdir bash -c 'F="{}"; mv -v "${F}" "${F%?????????????????}".syx' \;` *(fourth big red flag)*
6. At this point you can run `./trunc.sh` which, as the name suggests, will truncate all your sysex files so that they are now headerless
7. Now you can run `./syseXtractor.sh`: this is going to unpack all your sysex files into directories ending in `.DIR` *(fifth big red flag)* which, for each voice in the bank being extracted, will create two files: a `.tnm` file which will hold the voice name and a `.ssx` file which will hold the (compressed) voice data.
8. At this point you can run something like `fdupes` to find and delete all the duplicate voices in your collection while being careful to compare **only** the `.ssx` file. Something like `fdupes -r -G 100 -d -N .` will do the trick, by keeping the first instances of the duplicate voices it finds and deleting all the other ones. Pro-tip: if you have collections you'd really like to have as intact as possible (for example original Yamaha banks), make sure to name that folder in a way that will put it at the top alphabetically! (ex: `AA_Yamaha_Banks`)
9. Now you have a mess, because there are a bunch of `.tnm` files which are orphaned and need to be cleaned up *(sixth big red flag)*. To clean this up, run `./deleteEmpty.sh` which will scour your collection for those orphaned files and delete them.
10. Situation is a little better but, as you probably know, each bank must be filled with 32 Voices and now you have expanded banks with less than 32 voices. This is where `./aminet.sh` comes into play: this is the big one, you can't run it onto your entire collection, so you now have to move the entire library folder out of the folder where the scripts are and start putting each single "pack" or "collection" into the script folder so that the script can re-organize and re-make the banks for you by moving automatically all the various voices in order to fill each bank with 32 voices. For example, let's say you have a pack named "Robert" in your library: you now have to move the "Robert" folder into the script folder and run `./aminet.sh Robert` which will start processing all the voices and organize them in `Robert001.DIR, Robert002.DIR, Robert003.DIR, etc.` folder/banks. As you might have guessed, you can change the name of the folders to your liking by specifying it after the command. Bear in mind that this is going to be the name of the bank! *(I've lost count of the red flags. Seriously, you should not be doing this)*
11. Now you have all the voices in the correct places, but two issues remain: the name of the various files aren't the proper ones (they should be `01.*` to `32.*`) and, probably, the last bank still isn't filled up with 32 voices, which means you have to add empty voices yourself. To do this, just run `./createEmpty.sh` which will take care of all the renaming and adding empty voices. Those are going to be named `EMPTY     ` instead of Yamaha's spec `INIT VOICE`. If you want, you can change this by just editing the script file yourself, but if you're planning on using your library with MiniDexed, it's better if you leave it as it is, so that empty patches will get skipped automatically while browsing the voices on MiniDexed.
12. Now you can put the folder with the "pack" you've just sorted outside of the script's folder, put another one in and repeat steps 10 and 11 until you've done this for all your "packs".
13. After you've processed all the "packs" in your library, it's time to move the entire libary folder back into the script's folder, because you need to "re-pack" all the banks into sysex files. To do this, after you've moved your libary folder back into the script's folder, just run `./syscreator.sh` which is going to take care of it.
14. Congratulations! We're done! Bear in mind that your whole collection is, as of now, headerless, so if you want to have proper sysex files, you'll have to add the header back. You can do this with MDX_Tool, like we did before, by running `find . -iname "*.syx" -execdir MDX_Tool -r -f {} \;` and then `find . -type f -iname "*repaired*" -execdir bash -c 'F="{}"; mv -v "${F}" "${F%?????????????????}".syx' \;`
15. Finally, last step: if you want to use your library with Minidexed, you'll have to mass-rename all the sysex files to add a 5 digit number at the start. You can do this with `./minidexed.sh`
  
I hope I managed to discourage you enough from using those tools, thanks for reading.  

# What each script does

## aminet.sh

This script reorganizes your banks so that each bank will be filled up with 32 voices.  
The usage is `./aminet.sh NameOfTheCollection`. NameOfTheCollection is the name of the collection/pack you're re-organizing.  
It doesn't automatically add empty voices and rename the title and data files, so you'll have to run `./createEmpty.sh` after this.  
The script is named after the sysex collection "Aminet" which was what got me into doing those scripts.  

## checkCorrupt.sh

A complete trainwreck of a script which tries its hard to find broken/corrupted/non-working voices and delete them.  
The way it works, is that it checks the `.tnm` files for non-printable, non-ASCII characters, because broken voices often have binary data in their names and this script manages to catch them.  
It is terrible, unreliable and agonizingly slow.  
And I don't want to waste any more time on it.  

## countEmpty.sh

A simple script which will tell you how many empty voices each bank has.  
You can create a log file with this information by doing `./countEmpty.sh > log.txt`  

## createEmpty.sh

As the name suggests, this script checks each folder/bank (the `.DIR` folders) for missing voices and adds empty voices so that each bank has 32 voices as per spec.  
It also renames the files inside the folder/banks and it's meant to be run after `aminet.sh`.  
The empty voices are created with the `EMPTY     ` name which does not follow Yamaha's spec.  
It was meant to work with MiniDexed because voices named `EMPTY     ` are skipped so you don't have to scroll through hundreds of them.  
If you wish, you can change the name back to Yamaha's spec by uncommenting the line with `INIT VOICE` and commenting the other one.  

## deleteEmpty.sh

After finding and deleting duplicates, you're going to end up with a bunch of orphaned `.tnm` files. This script tracks those down and deletes them.  
It can also be used to find `EMPTY     ` patches and delete them, just uncomment that block and comment the other one.  

## minidexed.sh

MiniDexed requires you to have the sysex files in the `NNNNN_something.syx` format (where NNNNN is a number starting from 00001), so this script does that for you.  
**AS YOU MIGHT HAVE GUESSED, THIS DOESN'T CHECK IF YOUR FILES ARE ALREDY IN THE CORRECT FORMAT, IT JUST ADDS THE NUMBER**  

## syscreator.sh

Finds all `.DIR` directories which are created from `syseXtractor.sh` and converts them back to a sysex file (headerless!).  

## syseXtractor.sh

Finds all sysex files and splits them into separate voices.  
It creates a directory with the same name as the `.syx` file and adds a `.DIR` extension to it.  
Inside it creates `.tnm` files which hold the voice name and `.ssx` which hold the voice data.  
They are numbered from `01` to `32`.  
**IT MUST BE USED ONLY ON HEADERLESS SYSEX FILES**  

## trunc.sh

Finds all sysex files and removes the header from them.  
**BE CAREFUL THAT IT DOESN'T CHECK IF THE FILE HAS A HEADER IN THE FIRST PLACE, SO MAKE SURE THAT ALL YOUR SYSEX FILES HAVE A HEADER BEFORE RUNNING THIS** 
