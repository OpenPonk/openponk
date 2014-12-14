menu actions
newDiagramCommand
	| choice diagram |
	choice := UIManager default chooseFrom: #('Finite State Machine diagram' 'OntoUML diagram') title: 'Choices'.
	choice = 0
		ifTrue: [ ^ self ].
	choice = 1
		ifTrue: [ diagram := DCFsm new: 'FSM Diagram' ].
	choice = 2
		ifTrue: [ diagram := MetaModel new: 'OntoUML Diagram' ].
	self projectController project addDiagram: diagram