as yet unclassified
openProject
	FDOpenDirectoryDialog new
		whenSelected: [ :folder | self openProjectFromFolder: folder ];
		defaultFolder: FileLocator imageDirectory asFileReference;
		open