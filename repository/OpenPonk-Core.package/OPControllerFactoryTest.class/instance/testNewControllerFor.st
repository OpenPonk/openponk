tests
testNewControllerFor
	factory register: OPTestRelationController forModel: OPTestRelationModel.
	self
		assert: (factory newControllerFor: OPTestRelationModel new) class
		equals: OPTestRelationController