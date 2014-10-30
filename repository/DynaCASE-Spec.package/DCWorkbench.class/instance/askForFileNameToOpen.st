file support
askForFileNameToOpen
	"Ask user for file name to load content from"

	| result |
	result := UIManager default chooseFullFileNameMatching: #('*.ston') label: 'Choose project file to open'.
	result
		ifNotNil: [ 
			(result endsWith: '.ston')
				ifFalse: [ ^ nil ] ].
	^ result