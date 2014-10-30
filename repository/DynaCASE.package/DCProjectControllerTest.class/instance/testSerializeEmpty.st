tests
testSerializeEmpty
	"empty project without any diagrams"

	| controller project serialized |
	controller := DCProjectController new.
	(project := DCProject new) projectName: 'MyProject'.
	controller project: project.
	serialized := controller serializeProject.
	self assert: (serialized at: #version) = '1.1'.
	self assert: (serialized at: #created) asDate = DateAndTime now asDate.
	self assert: (serialized at: #project) = project