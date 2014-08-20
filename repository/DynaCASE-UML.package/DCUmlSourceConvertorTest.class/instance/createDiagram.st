as yet unclassified
createDiagram
	| diagram class |
	diagram := DCUmlClassDiagram new.
	class := DCUmlClass new name: 'DCUmlSCDummy'.
	class
		addAttribute:
				(DCUmlAttribute new
						name: 'firstInstnace';
						type: 'mixed';
						features: (DCUmlFeature new visibility: DCUmlFeature private);
						yourself);
		addAttribute:
				(DCUmlAttribute new
						name: 'secondInstance';
						type: 'String';
						features: (DCUmlFeature new visibility: DCUmlFeature private);
						yourself).
	class
		addOperation:
				(DCUmlOperation new
						name: 'firstInstance';
						features: DCUmlFeature new;
						returnValue: 'mixed';
						yourself);
		addOperation:
				(DCUmlOperation new
						name: 'firstInstance:';
						features: DCUmlFeature new;
						addParameter:
								(DCUmlParameter new
										name: 'anObject';
										type: 'mixed');
						yourself);
		addOperation:
				(DCUmlOperation new
						name: 'initialize';
						features: DCUmlFeature new;
						yourself).
	diagram add: class.
	^ diagram