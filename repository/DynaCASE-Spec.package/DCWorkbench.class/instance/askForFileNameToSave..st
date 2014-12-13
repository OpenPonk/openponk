file support
askForFileNameToSave: suggestedFileName
	"Ask user for the name of the file to save workspace content to. Use the given file name as the initial answer"

	^ UIManager default fileSave: 'Choose project file to save' extensions: #('ston')