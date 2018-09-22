Class {
	#name : #OPDiagramViewTest,
	#superclass : #TestCase,
	#instVars : [
		'view'
	],
	#category : #'OpenPonk-Core-Views'
}

{ #category : #tests }
OPDiagramViewTest >> testAsInfo [
	| info |
	view := OPDiagramView new
		name: 'default';
		model: OPTestContainerModel new;
		isOpen: true;
		isSelected: false;
		order: 7.
	info := view asInfo.
	self assert: info viewName equals: view name.
	self assert: info modelName equals: view modelName.
	self assert: info modelVersion equals: view modelVersion.
	self assert: info modelType equals: view modelType.
	self assert: info isOpen equals: view isOpen.
	self assert: info isSelected equals: view isSelected.
	self assert: info order equals: view order
]

{ #category : #tests }
OPDiagramViewTest >> testAsJsonComplex [
	view := OPDiagramView new
		camera:
			(OPDiagramViewCamera new
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
OPDiagramViewTest >> testAsJsonModel [
	view := OPDiagramView new
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
OPDiagramViewTest >> testAsJsonModel2 [
	view := OPDiagramView new model: OPTestContainerModel new.
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
OPDiagramViewTest >> testFromJsonComplex [
	view := OPDiagramView
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
OPDiagramViewTest >> testModel [
	| model project |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	view := OPDiagramView new
		modelName: 'container';
		modelType: 'OPTestContainerModel';
		project: project.
	self assert: view model equals: model
]

{ #category : #tests }
OPDiagramViewTest >> testModelDetached [
	view := OPDiagramView new.
	self should: [ view model ] raise: AssertionFailure
]

{ #category : #tests }
OPDiagramViewTest >> testNewCopy [
	| model project newView |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	view := OPDiagramView new
		name: 'original';
		camera:
			(OPDiagramViewCamera new
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
		assert: (project views includes: newView)
		description: [ 'Opposite test, because clone bypasses Synchronized Links' ].
	view
]

{ #category : #tests }
OPDiagramViewTest >> testUpdateFromInfo [
	| info |
	info := OPDiagramViewInfo new
		isOpen: true;
		isSelected: false;
		order: 7.
	view := OPDiagramView new updateFromInfo: info.
	self assert: info isOpen equals: view isOpen.
	self assert: info isSelected equals: view isSelected.
	self assert: info order equals: view order
]

{ #category : #tests }
OPDiagramViewTest >> testUpdateFromRoassalView [
	| roassalView |
	view := OPDiagramView new.
	roassalView := RTView new.
	roassalView canvas camera
		translateTo: 200 @ 27;
		scale: 0.23.
	view updateFromRoassalView: roassalView.
	self assert: view camera offset equals: 200 @ 27.
	self assert: view camera zoom equals: 0.23
]
