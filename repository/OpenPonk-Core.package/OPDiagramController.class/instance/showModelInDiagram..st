construction
showModelInDiagram: aModel
	| controller |
	controller := self newControllerFor: aModel.
	controller showInDiagram: self