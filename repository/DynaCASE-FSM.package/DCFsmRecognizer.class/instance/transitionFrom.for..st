private
transitionFrom: aState for: aSymbol
	^ aState outgoing detect: [ :each | each name = aSymbol ] ifNone: [ nil ]