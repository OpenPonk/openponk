as yet unclassified
openProjectFromFile
	FDOpenFileDialog new
		whenSelected: [ :file | self openProjectFromFile: file ];
		extensionFilters:
			{'OpenPonk projects' -> #('opp').
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		title: 'Select an OpenPonk project...';
		open