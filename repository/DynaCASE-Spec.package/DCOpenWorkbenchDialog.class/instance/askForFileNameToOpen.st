as yet unclassified
askForFileNameToOpen
	| path |
	path := UITheme builder fileOpen: 'Choose project file to open' extensions: #('ston').
	path ifNotNil: [ self openFile: path name ]