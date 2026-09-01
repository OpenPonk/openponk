"
Unit tests for OPLegacyDiagram. 
Ensures backward compatibility by verifying legacy JSON load mechanisms and updates.
"
Class {
	#name : 'OPLegacyDiagramTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram'
	],
	#category : 'OpenPonk-Core-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'LegacySupport-Diagrams'
}

{ #category : 'tests' }
OPLegacyDiagramTest >> testAsJsonComplex [
	diagram := OPLegacyDiagram new
		camera:
			(OPLegacyDiagramCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		layout:
			{('Person' -> (OPLegacyElementLayout withPosition: 27 @ 23 extent: 0 @ 0)).
			('Relationship'
				->
					(OPLegacyElementLayout
						withPathFromSource: 'Person' throughPoints:
							{(0 @ 0).
							(10 @ 10)}))} asDictionary.
	self
		assert: (STON fromString: diagram asJson)
		equals:
			(STON
				fromString:
					'{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 }	,
		"layout" : { 
			"Person" : { "position" : { "x" : 27, "y" : 23 }, "extent" : { "x" : 0, "y" : 0 } },
			"Relationship" : { "path" : { "source" : "Person", "points" : [ { "x" : 0, "y" : 0 }, { "x" : 10, "y" : 10 } ] } }
		}, 
		"commonElements" : [],
		"visibleElements" : [  ] }')
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testAsJsonModel [

	| model |
	model := Mock new.
	model stub class willReturn: OPTestContainerModel.
	model stub name willReturn: 'testComp'.
	model stub typeName willReturn: 'Component'.
	diagram := OPLegacyDiagram new model: model.
	self
		assert: (STON fromString: diagram asJson)
		equals:
		(STON fromString:
			 '{ "commonElements" : [], "visibleElements" : [ ] }')
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testAsJsonModel2 [
	diagram := OPLegacyDiagram new model: OPTestContainerModel new.
	self
		assert: (STON fromString: diagram asJson)
		equals: (STON fromString: '{ "commonElements" : [], "visibleElements" : [ ] }')
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testFromJsonComplex [

	| personUUID personUUIDstring person |
	personUUIDstring := '6b181c2c-135a-0d00-86ce-55e80f4cf59c'.
	personUUID := UUID fromString: personUUIDstring.
	person := Mock new.
	person stub uuid willReturn: personUUID.
	diagram := OPLegacyDiagram
		        ofModel: Mock new
		        fromJsonString:
			        '{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 },
		"layout" : { "6b181c2c-135a-0d00-86ce-55e80f4cf59c" : { "position" : { "x" : 27, "y" : 23 } } },
		"visibleElements" : [ "6b181c2c-135a-0d00-86ce-55e80f4cf59c" ]	 }'.
	self assert: diagram camera offset equals: 20 @ 30.
	self assert: diagram camera zoom equals: 1.2.
	self
		assert: diagram layout
		equals: { (personUUID -> (OPLegacyElementLayout withPosition: 27 @ 23)) }
				asOrderedDictionary.
	self
		assert: (diagram visibleElementsOrIfNotSet: [ { 1.2. 3 } ]) size
		equals: 1.
	self
		assert: (diagram visibleElementsOrIfNotSet: [ { 1.2. 3 } ]) anyOne
		equals: person
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testModel [

	| model  |
	model := OPTestContainerModel new.
	diagram := OPLegacyDiagram new.
	self assert: diagram modelType equals: 'UndefinedObject'.
	self assert: diagram model isNil.
	self assert: diagram modelName equals: 'UndefinedObject'.
	diagram model: model.
	self assert: diagram modelType equals: 'OPTestContainerModel'.
	self assert: diagram model class equals: OPTestContainerModel.
	self assert: diagram model name equals: 'container'.
	self assert: diagram modelName equals: 'container'.
	self assert: diagram model equals: model
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testNewCopy [
	| model project newView |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	diagram := OPLegacyDiagram new
		name: 'original';
		camera:
			(OPLegacyDiagramCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		model: model;
		isOpen: true;
		isSelected: false;
		order: 7.
	newView := diagram newCopy.
	self deny: newView = diagram.
	self assert: newView name equals: 'copy of original'.
	self assert: newView model equals: model.
	diagram
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testUpdateFromRoassalView [
	| roassalCanvas |
	diagram := OPLegacyDiagram new.
	roassalCanvas := RSCanvas new.
	roassalCanvas camera
		translateTo: 200 @ 27;
		scale: 0.23.
	diagram updateFromRoassalCanvas: roassalCanvas.
	self assert: diagram camera offset equals: 200 @ 27.
	self assert: diagram camera zoom equals: 0.23
]
