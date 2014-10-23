file support
askForFileNameToOpen
	"Ask user for file name to load content from"

	^ UIManager default chooseFullFileNameMatching: nil label: 'Choose project file to open'