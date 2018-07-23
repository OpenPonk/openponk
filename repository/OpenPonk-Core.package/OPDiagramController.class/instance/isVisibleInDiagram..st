testing
isVisibleInDiagram: aModel
	self controllerForModel: aModel ifFound: [ :ctrl | ^ true ].
	^ false