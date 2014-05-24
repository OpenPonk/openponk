tests
testExportClass
	| diagram class exporter file attr op |
	class := DCUmlClass new.
	class
		name: 'Test Class';
		features:
				(DCUmlFeature new
						isClassSide: true;
						isAbstract: true;
						stereotype: 'my stereo';
						visibility: 'public').
	attr := DCUmlAttribute new.
	attr
		name: 'first';
		type: 'bool';
		defaultValue: 'false';
		features:
				(DCUmlFeature new
						isClassSide: true;
						isAbstract: true;
						visibility: 'public').
	class addAttribute: attr.
	attr := DCUmlAttribute new.
	attr
		name: 'second';
		type: 'string';
		multiplicity:
				(DCUmlMultiplicity new
						min: '0';
						max: '2');
		features:
				(DCUmlFeature new
						isClassSide: false;
						isAbstract: false;
						visibility: 'private').
	class addAttribute: attr.
	op := DCUmlOperation new.
	op
		name: 'myMethod';
		features:
				(DCUmlFeature new
						isClassSide: true;
						isAbstract: true;
						visibility: 'public');
		returnValue:
				(DCUmlParameter new
						type: 'bool';
						defaultValue: 'not used');
		addParameter:
				(DCUmlParameter new
						name: 'firstParam';
						type: 'string');
		addParameter:
				(DCUmlParameter new
						name: 'secondParam';
						type: 'bool';
						defaultValue: 'false').
	class addOperation: op.
	file := '/tmp/testExport.txt'.
	exporter := DCUmlDummyExporter new.
	diagram := DCUmlClassDiagram new.
	diagram addElement: class.
	exporter fromDiagram: diagram toFile: file