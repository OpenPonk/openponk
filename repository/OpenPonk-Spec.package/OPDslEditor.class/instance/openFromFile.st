save/load
openFromFile
	| filename |
	filename := UITheme builder fileOpen: 'Choose a .txt file' extensions: #('txt').
	filename ifNil: [ ^ self ].
	location := filename name asFileReference.
	editor text: location contents