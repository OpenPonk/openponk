as yet unclassified
testTheCountofAssociations
	| kind1 kind2 kind3 kind4 asoc model |
	model := DCDiagram new.
	kind1 := Kind new name: 'A'.
	kind2 := Kind new name: 'B'.
	kind3 := Kind new name: 'C'.
	kind4 := Kind new name: 'D'.
	asoc := BasicAssociation new
		name: 'is>';
		end: kind1;
		start: kind2.
	model add: asoc.
	asoc := ComponentOf new
		end: kind3;
		start: kind2.
	model add: asoc.
	asoc := Derivation new
		end: kind2;
		start: kind4.
	model add: asoc.
	asoc := BasicAssociation new
		name: 'was>';
		end: kind2;
		start: kind2.
	model add: asoc.
	asoc := BasicAssociation new
		name: 'will>';
		end: kind2;
		start: kind4.
	model add: asoc.
	model
		add: kind1;
		add: kind2;
		add: kind3;
		add: kind4.
	self assert: kind2 relationships size = 5.
	self assert: kind1 relationships size = 1.
	self assert: kind3 relationships size = 1.
	self assert: kind4 relationships size = 2