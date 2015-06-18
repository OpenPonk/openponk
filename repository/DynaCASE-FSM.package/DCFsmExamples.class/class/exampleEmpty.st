examples
exampleEmpty
	| project fsm |
	project := DCProject new projectName: 'New StateMachine'.
	fsm := DCFsm new name: 'New StateMachine Diagram'.
	project addDiagram: fsm.
	DCWorkbench openProject: project