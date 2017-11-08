tests - connecting
testCanBeTargetForEntity
	self
		assert:
			(diagramController
				canBeTargetFor: (diagramController newControllerFor: OPTestEntityModel new))