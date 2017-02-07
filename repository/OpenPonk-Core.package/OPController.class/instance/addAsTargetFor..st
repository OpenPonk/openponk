adding
addAsTargetFor: aController
	(self canBeTargetFor: aController)
		ifTrue: [ self subclassResponsibility ]
		ifFalse: [ self error: self class asString , ' cannot be target for ' , aController class asString ]