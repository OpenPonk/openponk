adding
addAsTargetFor: aTransitionController
	self assert: (self canBeTargetFor: aTransitionController).
	aTransitionController target: self.
	aTransitionController attachTo: self diagramController.
	self model owner add: aTransitionController model