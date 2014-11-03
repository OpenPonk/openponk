examples
example2
	| diagram firstClass secondClass a1 project fsm initial first second t1 t2 t3 t4 final |
	project := DCProject new projectName: 'Example FSM + Umlite'.
	fsm := DCFsm new name: 'FS Diagram'.
	project addDiagram: fsm.
	initial := DCFsmInitialState new.
	first := DCFsmState new name: '1'.
	second := DCFsmState new name: '2'.
	final := DCFsmFinalState new name: '3'.
	fsm
		add: initial;
		add: first;
		add: second;
		add: final.
	t1 := DCFsmTransition from: initial to: first.
	(t2 := DCFsmTransition from: first to: second) name: 'a'.
	(t3 := DCFsmTransition from: second to: first) name: 'b'.
	(t4 := DCFsmTransition from: second to: final) name: 'a'.
	fsm
		add: t1;
		add: t2;
		add: t3;
		add: t4.
	diagram := DCUmliteDiagram new.
	project addDiagram: diagram.
	firstClass := DCUmliteClass new name: 'FirstClass'.
	firstClass attributes: #('-attr1' '-attr2') asOrderedCollection.
	secondClass := DCUmliteClass new
		name: 'SecondClass';
		attributes: #('-attrX') asOrderedCollection;
		yourself.
	(a1 := DCUmliteAssociation from: firstClass to: secondClass)
		name: 'association';
		sourceName: '+firstClass[1]';
		targetName: '+secondClass[1..*]'.
	diagram
		add: firstClass;
		add: secondClass;
		add: a1.
	^ self openProject: project