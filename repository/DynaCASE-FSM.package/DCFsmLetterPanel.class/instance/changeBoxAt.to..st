accessing
changeBoxAt: anIndex to: aSymbol

	self submorphs
		withIndexDo: [ :morph :index | 
			index < anIndex
				ifTrue: [ morph beSuccess ].
			index = anIndex
				ifTrue: [ morph perform: aSymbol ].
			index > anIndex
				ifTrue: [ morph beNormal ] ]