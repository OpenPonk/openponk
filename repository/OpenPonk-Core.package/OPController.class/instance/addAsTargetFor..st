connecting
addAsTargetFor: aController
	(self canBeTargetFor: aController)
		ifFalse: [ self error: self class asString , ' cannot be target for ' , aController class asString ].
	aController createModelIn: self model andShowInDiagram: self diagramController