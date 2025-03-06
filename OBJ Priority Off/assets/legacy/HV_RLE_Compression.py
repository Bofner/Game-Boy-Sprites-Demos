import sys
import binascii
import os
from pathlib import Path

# Globals to be considered as constants
FULL = 1024
SCRN = 360
TALL = 640
WIDE = 576
TILE = 1
MAP  = 0

# Run Byte Slice Run Length Encoding (BSRLE)
def main(args):
	# Check if we have a file given to the program
	if len(args) < 2:
		# If not, then quit
		print("Please give a tile map or tile data binary file as input.")
		exit()

	# The binary file
	tileData = args[1]

	# Header byte follows this format:
	# Most significant nibble
	# 7:   1 = TILE, 0 = MAP
	# 6:   1 = RAW Data
	# 5:   1 = FULL
	# 4:   1 = SCRN
	# 3:   1 = TALL, 0 = WIDE
	# 0-2: Unused
	header = "$00"

	# Check if we are compressing tiles or map
	pCompTiles = Path(tileData)
	fileName = pCompTiles.stem
	fileType = pCompTiles.suffix
	
	if fileType == ".map":
		dataType = 0
		print("Attempting to compress MAP data...")
	elif fileType == ".chr":
		dataType = 1
		print("Attempting to compress TILE data...")
	else:
		# Are we compressing tiles or maps?
		while True:
			# Looping multiple choice question 
			print(" \nIs the file MAP data or TILE data?")
			print("Map Data: Enter 0")
			print("Tile Data: Enter 1")
			dataType = input("Data Type: ")
			# Invalid choice check. Breaks us from the loop if a valid answer is selected
			try:
				dataType = int(dataType)
				if dataType == MAP or dataType == TILE:
					break
				else:
					print("\nInvalid entry. Please try again.")
			except:
				print("\nInvalid entry. Please try again.")

	# Check how big the file is
	# We will be dealing with files for maps of size: 
	#
	# TALL (160x256 pixels = 20x32 tiles =  640 bytes) | WIDE (256x144 pixels = 32x18 tiles = 576 bytes), 
	# FULL (256x256 pixels = 32x32 tiles = 1024 bytes) | SCRN (160x144 pixels = 20x18 tiles = 360 bytes)
	checkSize = open(tileData, mode = "rb")
	binFileSize = os.path.getsize(tileData)

	# Adjust the file if necessary
	if dataType == MAP and binFileSize > FULL:
		print("File size is too big. Files must be under 1024 bytes (256x256 pixel image).")
		checkSize.close()
		exit()
	elif dataType == MAP and binFileSize != 640 and binFileSize != 576 and binFileSize != 1024 and binFileSize != 360:
		# Pad with zeros if necessary
		appendBinary = open(tileData, mode = "ab")
		for x in range(1024 - binFileSize):
			appendBinary.write(b"\x00")
			binFileSize += 1
		appendBinary.close()
	checkSize.close()

	# Create a complimentary .inc file
	if dataType == TILE:
		incFile = open(fileName + "Tiles.inc", "w")
	elif dataType == MAP:
		incFile = open(fileName + "Map.inc", "w")
	else:
		print("Error with data type.")
		exit()

	# Set up our file with a comment describing the header format
	incFile.write(";Header byte follows this format:\n")
	incFile.write(";7:     1 = TILE, 0 = MAP\n")
	incFile.write(";6:     1 = Uncompressed\n")
	incFile.write(";5 & 4: 00 = SCRN, 01 = TALL\n")
	incFile.write(";       10 = WIDE, 11 = FULL\n")
	incFile.write(";0-3: Unused but set to 1\n")

	# Determine our header by first checking if it is worth compressing the file or not
	compFileSize = calc_comp_size(tileData, binFileSize)
	# Compression will only be efficient if we have a low number of runs (long strings of the same tile ID)
	if compFileSize > binFileSize:
		if dataType == MAP:
			header = "%01001111"
		elif dataType == TILE:
			header = "%11001111"
		incFile.write(".DB " + header)
		no_compression(tileData, incFile, binFileSize)
		incFile.close()
		print("File compression not efficient. Raw data with appropriate header copied instead.")
		print("Change in size would have been " + str(binFileSize) + " bytes to " + str(compFileSize) + " bytes.")

		exit()
	elif dataType == MAP and binFileSize == SCRN:
		header = "%00001111"
	elif dataType == MAP and binFileSize == TALL:
		header = "%00011111"
	elif dataType == MAP and binFileSize == WIDE:
		header = "%00101111"
	elif dataType == MAP and binFileSize == FULL:
		header = "%00111111"
	elif dataType == TILE:
		header = "%10001111"
	else:
		print("Error, incorrect file size.")
		exit()
	
	# Print how efficient the compression will be
	compEfficiency = int((1 - (compFileSize / binFileSize)) * 100)
	print("File compressed from " + str(binFileSize) + " bytes to " + str(compFileSize) + " bytes.")
	print("A " + str(compEfficiency) + "% reduction.")

	# Write our compression file
	incFile.write(".DB " + header)
	incFile.write("\n;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).\n")
	BSRLE_Compression(tileData, incFile, binFileSize)

	dataType = input("Press any key to close.")

	incFile.close()

	
def calc_comp_size(origBinFile, origSize):
	# Size of our BSRLE file, initialized to be JUST bigger than the FULL size
	compSize = 1025

	# The number of runs within our file
	# A "Run" is defined as a string of bytes that are the same as each other
	numRuns = 0	

	# Length of current run
	runLength = 0

	# Setup our previous byte to hold the first byte to check for a run
	checkCompression = open(origBinFile, mode = "rb")
	prevByte = checkCompression.read(1)

	# Find the total number of runs  for our RLE algorithm
	for x in range(origSize):
		# Read the next byte of data
		currentByte = checkCompression.read(1)
		# If the next byte isn't the same as the previous, then we have a new run
		if currentByte != prevByte:
			numRuns += 1
			prevByte = currentByte
		# If we reach a run of length 255 (0xFF) then we need to start a new run
		elif runLength >= 255:
			numRuns += 1
			runLength = 0
		# Otherwise our run continues
		else:
			runLength += 1

	# Calculate our compressed size: 
	# CompSize = numRuns * 2(runLength, tile ID) + 1(Header byte) + 1(Terminal byte)
	compSize = (numRuns * 2) + 1 + 1
	checkCompression.close()

	return compSize


def BSRLE_Compression(origBinFile, incFile, origSize):

	# Find number of runs to keep track of how many bytes we have on a single line
	runsPerLine = 0

	# Size of current run
	runLength = 1

	# Setup our previous byte to hold the first byte to check for a run 
	# and prepare the .DB tag 
	readBinary = open(origBinFile, mode = "rb")
	prevByte = readBinary.read(1)
	incFile.write(".DW ")

	# Find the next run
	for x in range(origSize):
		# Read the next byte of data
		currentByte = readBinary.read(1)
		if currentByte != prevByte:
			if runsPerLine >= 16:
				incFile.write("\n.DW ")
				runsPerLine = 0
			# Formatting for small run length vs 2 digit one
			if runLength < 16:
				incFile.write("$" + "0" + f"{runLength:x}")
			else:
				incFile.write("$" + f"{runLength:x}" )
			# Write our ID number
			incFile.write(prevByte.hex() + " ")
			# Update our variables
			runsPerLine += 1
			runLength = 1
			prevByte = currentByte
		# If we reach a run of length 255 (0xFF) then we need to start a new run
		elif runLength >= 255:
			# Write our run length
			incFile.write("$" + f"{runLength:x}" )
			# Write our ID number
			incFile.write(prevByte.hex() + " ")
			runsPerLine += 1
			runLength = 1
		# Otherwise our run continues
		else:
			runLength += 1

	# Write the terminator byte
	incFile.write("\n;Terminator word is $0000 since we can't have a run length of length 0.\n")
	incFile.write(".DW $0000\n")

	readBinary.close()


def no_compression(origBinFile, incFile, origSize):
	bytesPerLine = 0
	# Write our SIZE word
	incFile.write("\n;Size of uncompressed tile data:\n")
	if origSize < 16:
		incFile.write(".DW $000" + f"{origSize:x}")
	elif origSize < 256:
		incFile.write(".DW $00" + f"{origSize:x}")
	elif origSize < 4096:
		incFile.write(".DW $0" + f"{origSize:x}")
	else:
		incFile.write(".DW $" + f"{origSize:x}")
	incFile.write("\n;Raw tile data \n")
	# Setup our previous byte to hold the first byte to check for a run 
	# and prepare the .DB tag 
	readBinary = open(origBinFile, mode = "rb")
	currentByte = readBinary.read(1)
	incFile.write(".DB ")

	# Find the next run
	for x in range(origSize):
		# Write current byte
		# Read the next byte of data
		if bytesPerLine >= 16:
				incFile.write("\n.DB ")
				bytesPerLine = 0
		incFile.write("$" + currentByte.hex() + " ")
		bytesPerLine += 1
		currentByte = readBinary.read(1)

	readBinary.close()

# Start of our program
main(sys.argv)