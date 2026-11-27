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
	#category : 'OpenPonk-Core-Tests-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core-Tests',
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
OPLegacyDiagramTest >> testAsOPDiagramSkipsUnsupportedVisibleElements [

	| container entity unsupported legacy opDiagram |
	[
		OPPluginRegistry setDefaultForTesting.
		container := OPTestContainerModel new.
		container instVarNamed: #uuid put: UUID new.
		entity := OPTestEntityModel new.
		entity instVarNamed: #uuid put: UUID new.
		unsupported := OPTestContainerModel new.
		unsupported instVarNamed: #uuid put: UUID new.
		container
			add: entity;
			add: unsupported.

		legacy := OPLegacyDiagram emptyOfModel: container.
		legacy
			name: 'Legacy Unsupported Visible Element';
			camera: (OPLegacyDiagramCamera new
					 offset: 0 @ 0;
					 zoom: 1;
					 yourself);
			visibleElements: {
					(OPModelObjectReference withUUID: entity uuid).
					(OPModelObjectReference withUUID: unsupported uuid) };
			layout: { (entity uuid -> (OPLegacyElementLayout withPosition: 100 @ 120 extent: 80 @ 60)) } asDictionary.

		opDiagram := legacy asOPDiagram.
		self assertCollection: (opDiagram ownedElements collect: #modelElement) hasSameElements: { entity } ] ensure: [
		OPPluginRegistry resetDefault ]
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testFromJsonComplex [

	| personUUID personUUIDstring person |
	personUUIDstring := '6b181c2c-135a-0d00-86ce-55e80f4cf59c'.
	personUUID := UUID fromString: personUUIDstring.
	person := Mock new.
	person stub uuid willReturn: personUUID.
	diagram := OPLegacyDiagram ofModel: Mock new fromJsonString: '{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 },
		"layout" : { "6b181c2c-135a-0d00-86ce-55e80f4cf59c" : { "position" : { "x" : 27, "y" : 23 } } },
		"visibleElements" : [ "6b181c2c-135a-0d00-86ce-55e80f4cf59c" ]	 }'.
	self assert: diagram camera offset equals: 20 @ 30.
	self assert: diagram camera zoom equals: 1.2.
	self assert: diagram layout equals: { (personUUID -> (OPLegacyElementLayout withPosition: 27 @ 23)) } asOrderedDictionary.
	self assert: (diagram visibleElementsOrIfNotSet: [ { 1. 2. 3 } ]) size equals: 1.
	self assert: (diagram visibleElementsOrIfNotSet: [ { 1. 2. 3 } ]) anyOne equals: person
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testJsonRoundtripCommonElementsVisibleElementsAndMetadata [

	| note legacy jsonString parsed container nonUuidRef |
	self assert: OPLegacyDiagram isDeprecated description: 'OPLegacyDiagram should be marked as deprecated'.
	self assert: OPLegacyDiagramCamera isDeprecated description: 'OPLegacyDiagramCamera should be marked as deprecated'.
	container := OPTestContainerModel new
		             name: 'MyContainer';
		             yourself.
	note := OPNote new
		        text: 'Legacy Note';
		        yourself.
	legacy := OPLegacyDiagram emptyOfModel: container.
	self assert: legacy order equals: 0.
	legacy
		name: 'Roundtrip Diagram';
		order: 3;
		isOpen: true;
		isSelected: false;
		camera: (OPLegacyDiagramCamera new
				 offset: 12 @ 34;
				 zoom: 1.5;
				 yourself);
		commonElements: { note };
		visibleElements: { note };
		layout: {
				(note uuid -> (OPLegacyElementLayout withPosition: 10 @ 20 extent: 30 @ 40)).
				('legacy-non-uuid' -> (OPLegacyElementLayout withPathFromSource: note uuid throughPoints: {
						  (0 @ 0).
						  (10 @ 10) })) } asDictionary.
	self assert: legacy order equals: 3.
	self assertCollection: legacy commonElements hasSameElements: { note }.
	self assert: (legacy printString includesSubstring: 'Roundtrip Diagram') description: 'printOn: should include diagram name'.
	self assert: (legacy printString includesSubstring: 'MyContainer') description: 'printOn: should include model name'.

	jsonString := OPJsonWriter toString: legacy.
	parsed := OPLegacyDiagram ofModel: container fromJsonString: jsonString.
	self assert: parsed name equals: 'Roundtrip Diagram'.
	self assert: parsed commonElements size equals: 1.
	self assert: parsed commonElements first class identicalTo: OPNote.
	self assert: parsed commonElements first text equals: 'Legacy Note'.
	self assert: parsed layout size equals: 2.
	self assert: (parsed layout at: note uuid) position equals: 10 @ 20.
	self
		assert: (parsed layout includesKey: 'legacy-non-uuid')
		description: 'Layout decoding should preserve non-UUID keys as strings'.

	nonUuidRef := OPLegacyDiagram ofModel: container fromJsonString: '{"visibleElements":["plain-id"]}'.
	self assert: (nonUuidRef visibleElementsOrIfNotSet: [ #(  ) ]) first uuid equals: 'plain-id'.

	parsed visibleElements: nil.
	self assert: (parsed visibleElementsOrIfNotSet: [ { note } ]) asArray equals: { note }
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testModel [

	| model |
	model := OPTestContainerModel new.
	diagram := OPLegacyDiagram new.
	self assert: diagram model identicalTo: nil.
	self assert: diagram modelName equals: 'UndefinedObject'.
	diagram model: model.
	self assert: diagram model class equals: OPTestContainerModel.
	self assert: diagram model name equals: 'container'.
	self assert: diagram modelName equals: 'container'.
	self assert: diagram model equals: model
]

{ #category : 'tests' }
OPLegacyDiagramTest >> testModelObjectReferenceHashAndPrintOn [

	| uuid firstReference secondReference nilReference |
	uuid := UUID new.
	firstReference := OPModelObjectReference withUUID: uuid.
	secondReference := OPModelObjectReference withUUID: uuid.
	nilReference := OPModelObjectReference new.
	self assert: firstReference hash equals: secondReference hash.
	self assert: firstReference hash equals: uuid hash.
	self
		assert: (firstReference printString includesSubstring: uuid asString)
		description: 'printOn: should include UUID when present'.
	self deny: (nilReference printString includesSubstring: '(') description: 'printOn: should omit parentheses when UUID is nil'
]
