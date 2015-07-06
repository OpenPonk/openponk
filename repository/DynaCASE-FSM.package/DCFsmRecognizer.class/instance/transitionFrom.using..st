private
transitionFrom: aState using: aSymbol
	^ aState outgoing detect: [ :each | each name = aSymbol asString ] ifNone: [ nil ]