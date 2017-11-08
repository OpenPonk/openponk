connecting
addAsSourceFor: aController
	(self canBeSourceFor: aController)
		ifFalse: [ self error: self class asString , ' cannot be source for ' , aController class asString ].
	aController sourceController: self