running
testRemovingOfRelationships
	| kind subkind1 subkind2 kind3 role kind2 basicAsoc1 generalization1 generalization2 generalization3 basicAsoc2 basicAsoc3 memberOf model |
	model := DCOmlDiagram new.
	kind := Kind new name: 'Boss'.
	subkind1 := SubKind new name: 'Big Boss'.
	subkind2 := SubKind new name: 'Small Boss'.
	role := Role new name: 'Observer'.
	kind2 := Kind new name: 'Binocular'.
	kind3 := Kind new name: 'Senate'.
	basicAsoc1 := BasicAssociation new
		start: role;
		end: kind2.
	generalization1 := Generalization new
		parent: kind;
		child: subkind1.
	generalization2 := Generalization new
		parent: kind;
		child: subkind2.
	generalization3 := Generalization new
		parent: role;
		child: subkind2.
	basicAsoc2 := BasicAssociation new
		start: kind;
		end: kind.
	basicAsoc3 := BasicAssociation new
		start: kind3;
		end: kind2.
	memberOf := MemberOf new
		start: kind;
		end: kind3.
	model
		add: kind;
		add: kind2;
		add: kind3;
		add: subkind1;
		add: subkind2;
		add: role;
		add: generalization1;
		add: generalization2;
		add: generalization3;
		add: basicAsoc1;
		add: basicAsoc2;
		add: basicAsoc3;
		add: memberOf.	"testing"
	model remove: subkind1.
	self deny: (model has: generalization1).
	self assert: (model has: generalization2).
	model remove: kind3.
	self deny: (model has: basicAsoc3).
	self deny: (model has: memberOf).
	model remove: kind.
	self deny: (model has: generalization2).
	self deny: (model has: basicAsoc2).
	model remove: kind2.
	self deny: (model has: basicAsoc1)	"self assert:(((model elements)size=2) )."