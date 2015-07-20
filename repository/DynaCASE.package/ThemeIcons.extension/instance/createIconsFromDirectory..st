*DynaCASE-Icons
createIconsFromDirectory: aDirectory
	| dir files theme |
	dir := aDirectory asFileReference.
	files := (dir allFiles select: [ :each | each extension = 'png' ]) collect: [ :each | each base ].
	theme := Smalltalk ui icons.
	files do: [ :each | theme createIconMethodsFromFile: each directory: dir ].
	self initializeIcons