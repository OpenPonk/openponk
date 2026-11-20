"
Unit tests for OPJsonDiagramSerializer. 
Verifies the correct serialization and deserialization of diagrams into JSON format.
"
Class {
	#name : 'OPJsonDiagramSerializerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Persistence',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Persistence'
}

{ #category : 'tests' }
OPJsonDiagramSerializerTest >> testMaterializeDiagramOfFromStream [

	| container entity jsonString serializer diagram entityShape |
	OPPluginRegistry setDefaultForTesting.
	[
		container := OPTestContainerModel new.
		container instVarNamed: #uuid put: UUID new.
		entity := OPTestEntityModel new.
		entity instVarNamed: #uuid put: UUID new.
		container add: entity.
		jsonString := String streamContents: [ :stream |
				              stream
					              nextPutAll:
						              '{"name":"Migrated","isOpen":true,"isSelected":false,"camera":{"offset":{"x":0,"y":0},"zoom":1.0},"layout":{"';
					              nextPutAll: entity uuid asString;
					              nextPutAll: '":{"position":{"x":40,"y":60},"extent":{"x":80,"y":50}}},"visibleElements":["';
					              nextPutAll: entity uuid asString;
					              nextPutAll: '"]}' ].
		serializer := OPJsonDiagramSerializer new.
		diagram := serializer materializeDiagramOf: container from: jsonString readStream.
		self assert: diagram class identicalTo: OPOpenPonkDiagram.
		self assert: diagram name equals: 'Migrated'.
		self assert: diagram isOpen description: 'Materialized legacy diagram should preserve isOpen'.
		entityShape := diagram ownedElements detect: [ :each | each modelElement == entity ].
		self assert: entityShape bounds position equals: 40 @ 60.
		self assert: entityShape bounds extent equals: 80 @ 50 ] ensure: [ OPPluginRegistry resetDefault ]
]

{ #category : 'tests' }
OPJsonDiagramSerializerTest >> testMetadataAndExportInfoLookup [

	| exportInfo serializer |
	self assert: OPJsonDiagramSerializer exportVersion equals: 1.
	self assert: OPJsonDiagramSerializer minImportVersion equals: 1.
	self assert: OPJsonDiagramSerializer formatName equals: #json.
	exportInfo := OPExportInfo new
		              subject: #diagram;
		              format: #json;
		              version: 1;
		              yourself.
	serializer := OPSerializer forExportInfo: exportInfo.
	self assert: serializer class identicalTo: OPJsonDiagramSerializer
]

{ #category : 'tests' }
OPJsonDiagramSerializerTest >> testSerializeDiagramRaisesShouldNotImplement [

	| serializer diagram stream |
	serializer := OPJsonDiagramSerializer new.
	diagram := OPOpenPonkDiagram forModelElement: OPTestContainerModel new.
	stream := WriteStream on: String new.
	self should: [ serializer serializeDiagram: diagram to: stream ] raise: ShouldNotImplement
]
