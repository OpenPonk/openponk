adding
addAsSourceFor: aTransitionController
	self assert: (self canBeSourceFor: aTransitionController).
	aTransitionController source: self