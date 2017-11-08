tests - connecting
testCanBeTargetForRelation
	self
		assert:
			(controller
				canBeTargetFor: (diagramController newControllerFor: OPTestRelationModel new))