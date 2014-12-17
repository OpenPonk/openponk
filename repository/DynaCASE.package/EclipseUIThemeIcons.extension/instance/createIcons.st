*DynaCASE-Icons
createIcons
	| dir files theme |
	dir := '/home/peter/prog/dynacase/icons' asFileReference.
	files := (dir allFiles select: [ :each | each extension = 'png' ]) collect: [ :each | each base ].
	theme := ThemeIcons current.
	files do: [ :each | theme createIconMethodsFromFile: each directory: dir ]