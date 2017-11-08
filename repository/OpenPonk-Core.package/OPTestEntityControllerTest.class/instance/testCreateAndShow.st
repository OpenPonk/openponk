tests - construction
testCreateAndShow
	| subModel |
	controller createModelIn: diagramController model andShowInDiagram: diagramController.
	self assert: diagramController model entities isNotEmpty.
	subModel := diagramController model entities first.
	self assert: diagramController controllers asArray equals: {controller}.
	self assert: (diagramController view elements includes: controller figure)