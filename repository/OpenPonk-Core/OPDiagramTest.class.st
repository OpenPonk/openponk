Class {
	#name : #OPDiagramTest,
	#superclass : #TestCase,
	#instVars : [
		'view'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #tests }
OPDiagramTest >> testAsInfo [
	| info |
	view := OPDiagram new
		name: 'default';
		model: OPTestContainerModel new;
		isOpen: true;
		isSelected: false;
		order: 7.
	info := view asInfo.
	self assert: info diagramName equals: view name.
	self assert: info modelName equals: view modelName.
	self assert: info modelVersion equals: view modelVersion.
	self assert: info modelType equals: view modelType.
	self assert: info isOpen equals: view isOpen.
	self assert: info isSelected equals: view isSelected.
	self assert: info order equals: view order
]

{ #category : #tests }
OPDiagramTest >> testAsJsonComplex [
	view := OPDiagram new
		camera:
			(OPDiagramCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		project: OPProject new;
		layout: {'Person' -> (27 @ 23)} asDictionary;
		options: {'key' -> 'value'} asDictionary.
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 }	,
		"filters" : [  ],
		"layout" : { "Person" : { "x" : 27, "y" : 23 } },
		"options" : { "key" : "value" },
		"visibleElements" : [  ] }')
]

{ #category : #tests }
OPDiagramTest >> testAsJsonModel [
	view := OPDiagram new
		modelName: 'testComp';
		modelType: 'Component';
		modelVersion: '1.0'.
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{"filters": [],"visibleElements" : [ ],"options": { },
					"modelName" : "testComp",
					"modelType" : "Component",
					"modelVersion" : "1.0"
}')
]

{ #category : #tests }
OPDiagramTest >> testAsJsonModel2 [
	view := OPDiagram new model: OPTestContainerModel new.
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{"filters": [],"visibleElements" : [ ], "options" : {  },
					"modelName" : "container",
					"modelType" : "OPTestContainerModel"
}')
]

{ #category : #tests }
OPDiagramTest >> testFromJsonComplex [
	view := OPDiagram
		fromJson:
			'{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 },
		"layout" : { "Person" : { "x" : 27, "y" : 23 } },
		"options" : { "key" : "value" },
		"visibleElements" : [ "Person" ]	 }'.
	self assert: view camera offset equals: 20 @ 30.
	self assert: view camera zoom equals: 1.2.
	self assert: view layout equals: {'Person' -> (27 @ 23)} asDictionary.
	self assert: view visibleElements equals: #('Person').
	self assert: view project isNil.
	self assert: view options equals: { 'key' -> 'value' } asDictionary.
]

{ #category : #tests }
OPDiagramTest >> testModel [
	| model project |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	view := OPDiagram new
		modelName: 'container';
		modelType: 'OPTestContainerModel';
		project: project.
	self assert: view model equals: model
]

{ #category : #tests }
OPDiagramTest >> testModelDetached [
	view := OPDiagram new.
	self should: [ view model ] raise: AssertionFailure
]

{ #category : #tests }
OPDiagramTest >> testNewCopy [
	| model project newView |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	view := OPDiagram new
		name: 'original';
		camera:
			(OPDiagramCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		model: model;
		project: project;
		isOpen: true;
		isSelected: false;
		order: 7.
	newView := view newCopy.
	self deny: newView = view.
	self assert: newView name equals: 'copy of original'.
	self assert: newView project equals: project.
	self assert: newView model equals: model.
	self
		assert: (project diagrams includes: newView)
		description: [ 'Opposite test, because clone bypasses Synchronized Links' ].
	view
]

{ #category : #tests }
OPDiagramTest >> testUpdateFromInfo [
	| info |
	info := OPDiagramInfo new
		isOpen: true;
		isSelected: false;
		order: 7.
	view := OPDiagram new updateFromInfo: info.
	self assert: info isOpen equals: view isOpen.
	self assert: info isSelected equals: view isSelected.
	self assert: info order equals: view order
]

{ #category : #tests }
OPDiagramTest >> testUpdateFromRoassalView [
	| roassalView |
	view := OPDiagram new.
	roassalView := RTView new.
	roassalView canvas camera
		translateTo: 200 @ 27;
		scale: 0.23.
	view updateFromRoassalView: roassalView.
	self assert: view camera offset equals: 200 @ 27.
	self assert: view camera zoom equals: 0.23
]
