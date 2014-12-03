as yet unclassified
testTheCountOfGeneralizations
	| kind subkind1 subkind2 subkind3 subkind4 generalization model |
	model := DCDiagram new.
	kind := Kind new name: 'Parent'.
	subkind1 := SubKind new name: 'C1'.
	subkind2 := SubKind new name: 'C2'.
	subkind3 := SubKind new name: 'C3'.
	subkind4 := SubKind new name: 'C4'.
	model
		add: kind;
		add: subkind1;
		add: subkind2;
		add: subkind3;
		add: subkind4.
	generalization := Generalization new
		parent: kind;
		child: subkind1.
	model add: generalization.
	generalization := Generalization new
		parent: kind;
		child: subkind2.
	model add: generalization.
	self assert: kind generalizations size = 2.
	self assert: subkind1 generalizations size = 1.
	generalization := Generalization new
		parent: kind;
		child: subkind3.
	model add: generalization.
	generalization := Generalization new
		parent: kind;
		child: subkind4.
	model add: generalization.
	self assert: kind generalizations size = 4