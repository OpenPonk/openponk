menu actions
newDiagramCommand
	| choice diagram |
	choice := UIManager default chooseFrom: #('Finite State Machine diagram' 'OntoUML diagram') title: 'Choices'.
	choice = 0
		ifTrue: [ ^ self ].
	choice = 1
		ifTrue: [ diagram := DCFsm new name: 'FSM Diagram' ].
	choice = 2
		ifTrue: [ diagram := DCOmlDiagram new name: 'OntoUML Diagram' ].
	self projectController project addDiagram: diagram