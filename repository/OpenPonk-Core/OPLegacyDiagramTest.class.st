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
OPLegacyDiagramTest >> testAsOPDiagramConvertsLegacyLayoutsAndCommonElements [
	| container entity1 entity2 rel note legacy opDiagram entity1Element entity2Element relElement |
	[
		OPPluginRegistry setDefaultForTesting.
		container := OPTestContainerModel new.
		container instVarNamed: #uuid put: UUID new.
		entity1 := OPTestEntityModel new.
		entity1 instVarNamed: #uuid put: UUID new.
		entity2 := OPTestEntityModel new.
		entity2 instVarNamed: #uuid put: UUID new.
		rel := OPTestRelationModel new
			source: entity1;
			target: entity2;
			yourself.
		rel instVarNamed: #uuid put: UUID new.
		container
			add: entity1;
			add: entity2;
			add: rel.
		note := OPNote new text: 'Migrated Note'; yourself.

		legacy := OPLegacyDiagram emptyOfModel: container.
		legacy
			name: 'Legacy Diagram';
			isOpen: true;
			isSelected: true;
			order: 2;
			camera: (OPLegacyDiagramCamera new offset: 15 @ 25; zoom: 1.25; yourself);
			commonElements: { note };
			visibleElements: {
				OPModelObjectReference withUUID: entity1 uuid.
				OPModelObjectReference withUUID: entity2 uuid.
				OPModelObjectReference withUUID: rel uuid.
				OPModelObjectReference withUUID: note uuid };
			layout: {
				entity1 uuid -> (OPLegacyElementLayout withPosition: 100 @ 120 extent: 80 @ 60).
				entity2 uuid -> (OPLegacyElementLayout withPosition: 300 @ 120).
				rel uuid -> (OPLegacyElementLayout
					withPathFromSource: entity1 uuid
					throughPoints: { 100 @ 120 . 200 @ 160 . 300 @ 120 }) } asDictionary.

		opDiagram := legacy asOPDiagram.
		self assert: opDiagram class identicalTo: OPOpenPonkDiagram.
		self assert: opDiagram name equals: 'Legacy Diagram'.
		self assert: opDiagram isOpen description: 'Converted diagram should preserve isOpen'.
		self assert: opDiagram isSelected description: 'Converted diagram should preserve isSelected'.
		self assert: (opDiagram ownedElements includes: note)
			description: 'Converted diagram should own migrated common element note'.

		entity1Element := opDiagram ownedElements detect: [ :each | each modelElement == entity1 ].
		entity2Element := opDiagram ownedElements detect: [ :each | each modelElement == entity2 ].
		relElement := opDiagram ownedElements detect: [ :each | each modelElement == rel ].
		self assert: entity1Element bounds position equals: 100 @ 120.
		self assert: entity1Element bounds extent equals: 80 @ 60.
		self assert: entity2Element bounds position equals: 300 @ 120.
		self assert: relElement innerWaypoints asArray equals: { 200 @ 160 }
	] ensure: [ OPPluginRegistry resetDefault ]
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
	| model |
	model := OPTestContainerModel new.
	diagram := OPLegacyDiagram new.
	self assert: diagram model isNil description: 'New OPLegacyDiagram should have nil model initially'.
	self assert: diagram modelName equals: 'UndefinedObject'.
	diagram model: model.
	self assert: diagram model class equals: OPTestContainerModel.
	self assert: diagram model name equals: 'container'.
	self assert: diagram modelName equals: 'container'.
	self assert: diagram model equals: model
]
