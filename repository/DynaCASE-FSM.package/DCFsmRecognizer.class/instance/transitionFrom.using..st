private
transitionFrom: aState using: aSymbol
	^ aState outgoing detect: [ :each | each matches: aSymbol asString ] ifNone: [ nil ]