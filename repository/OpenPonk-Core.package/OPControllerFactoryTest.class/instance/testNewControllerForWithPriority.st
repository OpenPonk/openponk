tests
testNewControllerForWithPriority
	factory
		register: OPTestEntityController
		forModel: OPTestRelationModel
		condition: [ :aModel | aModel source isNotNil ].
	factory register: OPTestRelationController forModel: OPTestRelationModel.
	self
		assert: (factory newControllerFor: OPTestRelationModel new) class
		equals: OPTestRelationController.
	self
		assert: (factory newControllerFor: (OPTestRelationModel new source: 12)) class
		equals: OPTestEntityController