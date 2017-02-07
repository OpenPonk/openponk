adding
addAsSourceFor: aController
	(self canBeSourceFor: aController)
		ifTrue: [ self subclassResponsibility ]
		ifFalse: [ self error: self class asString , ' cannot be source for ' , aController class asString ]