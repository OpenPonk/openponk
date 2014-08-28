instance creation
open
	| fsm |
	fsm := DCFsm new.
	self new
		open;
		openDiagram: fsm