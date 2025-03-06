import sys
import binascii
import os
from pathlib import Path

# Check if we have a file given to the program
if len(sys.argv) < 2:
	# If not, then quit
	print("Please give a CGB.pal binary file as input.")
	exit()

# The CGB.pal binary file
palCGB = sys.argv[1]

# Check how many palettes the file contains, ideally 1, 2, 3 or 4 (8, 15, 22, 30 bytes)
checkSize = open(palCGB, mode = "rb")
size = os.path.getsize(palCGB)
if size != 8 and size != 14 and size != 22 and size != 28:
		print("Incorrect file size")
		checkSize.close()
		exit()
checkSize.close()

# Adjust the size of our file if necessary
if size == 8 or size == 20:	
	# If 8 or 24, then append the file with zeros
	appendBinary = open(palCGB, mode = "ab")
	appendBinary.write(b"\x00\x00\x00\x00\x00\x00\x00\x00")
	appendBinary.close()
	size += 8

# Select which SGB palettes to write to
if size <= 14:
	while True:
		# Looping multiple choice question 
		print(" \nWhich two SGB palettes do you want to use?")
		print("SGB Palette 0 & 1: Enter 0")
		print("SGB Palette 2 & 3: Enter 1")
		print("SGB Palette 0 & 3: Enter 2")
		print("SGB Palette 1 & 2: Enter 3")
		paletteChoice = input("First SGB Palette: ")
		# Invalid choice check. Breaks us from the loop if a valid answer is selected
		try:
			paletteChoice = int(paletteChoice)
			if paletteChoice <= 3 and paletteChoice >=0:
				break
			else:
				print("\nInvalid entry. Please try again.")
		except:
			print("\nInvalid entry. Please try again.")
	# Set up our first byte header and inc file comments
	if paletteChoice == 0:
		sgbPalettes0 = "0 and 1"
		sgbPalettesHeader0 = ' $01'
	elif paletteChoice == 1:
		sgbPalettes0 = "2 and 3"
		sgbPalettesHeader0 = ' $09'
	elif paletteChoice == 2:
		sgbPalettes0 = "0 and 3"
		sgbPalettesHeader0 = ' $11'
	elif paletteChoice == 3:
		sgbPalettes0 = "1 and 2"
		sgbPalettesHeader0 = ' $19'
	else:
		print(paletteChoice)
		print("Error, palette choice is invalid.")
		exit()
	numberOfPackets = 1
	sgbPalettes1 = "No second packet,"
	sgbPalettesHeader1 = "So this should not write."
else:
	# Default palettes will be SGB0 and SGB1 first and SGB2 and SGB3 after
	# for files that use 4 palettes
	sgbPalettes0 = "0 and 1"
	sgbPalettesHeader0 = ' $01'
	sgbPalettes1 = "2 and 3"
	sgbPalettesHeader1 = ' $09'
	numberOfPackets = 2
	

# Create a complimentary .inc file
pCGB = Path(palCGB)
fileName = pCGB.stem
incFile = open(fileName + "Pal.inc", "w")

# Set up our file and write the header
readBinary = open(palCGB, mode = "rb")

for x in range(numberOfPackets):
	incFile.write(';Data for 16 byte packet that sets SGB Palettes ' + sgbPalettes0 + ' \n;Header\n')
	incFile.write('.DB' + sgbPalettesHeader0 + '\n;Color Data\n.DW')

	# Read through 8 words of data, but skip 9th word since it is already accounted for with
	# the Pal 0 index palette color of the previous palette 
	for words in range(8):
		# Read a word from the binary file
		if words != 4:
			colorValue = readBinary.read(2)
			hexWord = colorValue.hex(' ', 2)
			# Swap the bytes so they'll be read by the SNES in Little Endian order
			incFile.write(' $' + hexWord[2:] + hexWord[:2])


	# Final comment
	incFile.write('\n;Extra Byte\n.DB $00' + ' \n' + ';End of SGB Packet\n \n')
	# Put second packet header data into the first packet header
	sgbPalettes0 = sgbPalettes1
	sgbPalettesHeader0 = sgbPalettesHeader1

incFile.close()
readBinary.close()



