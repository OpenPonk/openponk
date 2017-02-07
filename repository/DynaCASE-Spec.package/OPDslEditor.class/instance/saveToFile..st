save/load
saveToFile: aPath
	| newLocation |
	newLocation := aPath.
	newLocation
		ifNil: [ newLocation := UITheme builder fileSave: 'Save to .txt file' extensions: #('txt') ].
	newLocation ifNil: [ ^ self ].
	location := newLocation.
	location ensureDelete.
	location writeStream nextPutAll: editor text.
	self updateModel