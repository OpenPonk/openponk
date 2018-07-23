figures
hideModelFromDiagram: aModel
	self controllerForModel: aModel ifFound: [ :ctrl | ctrl removeController ]