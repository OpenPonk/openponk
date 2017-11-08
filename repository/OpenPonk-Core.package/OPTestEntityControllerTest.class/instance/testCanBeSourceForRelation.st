tests - connecting
testCanBeSourceForRelation
	self
		assert:
			(controller
				canBeSourceFor: (diagramController newControllerFor: OPTestRelationModel new))