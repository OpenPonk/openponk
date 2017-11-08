destruction
removeModel
	| ownerModel |
	ownerModel := self diagramController model.
	ownerModel entities remove: self model