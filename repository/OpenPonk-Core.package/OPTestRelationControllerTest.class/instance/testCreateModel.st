tests - construction
testCreateModel
	controller createModelIn: diagramController model.
	self assert: controller model isNotNil.
	self assert: diagramController model entities asArray equals: {controller model}