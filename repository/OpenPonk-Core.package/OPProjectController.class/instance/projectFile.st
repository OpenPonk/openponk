accessing
projectFile
	self project storageFile
		ifNil: [ self project
				storageFile:
					(FDSaveFileDialog new
						extensionFilters:
							{'OpenPonk projects' -> #('opp').
							'All files' -> #()};
						defaultFolder: FileLocator imageDirectory asFileReference;
						openModal) ].
	^ self project storageFile