adding
addAsTargetFor: aController
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController attachTo: self diagramController