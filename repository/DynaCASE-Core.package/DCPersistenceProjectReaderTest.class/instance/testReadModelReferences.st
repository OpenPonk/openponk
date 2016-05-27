tests
testReadModelReferences
	| references |
	references := reader readModelReferences: root.
	self
		assert: references first
		equals: project models first uuid -> DCPluginRegistry default plugins first