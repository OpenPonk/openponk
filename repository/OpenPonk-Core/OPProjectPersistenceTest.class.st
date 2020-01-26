Class {
	#name : #OPProjectPersistenceTest,
	#superclass : #TestCase,
	#instVars : [
		'persistence'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #running }
OPProjectPersistenceTest >> setUp [
	super setUp.
	persistence := OPProjectPersistence new.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new)
]

{ #category : #running }
OPProjectPersistenceTest >> tearDown [
	OPPluginRegistry resetDefault
]

{ #category : #tests }
OPProjectPersistenceTest >> testCreateFolderStructure [
	| root |
	root := FileSystem memory root / 'project'.
	persistence saveProject: OPProject new to: root.
	self assert: root isDirectory.
	self assert: (root / 'project.json') isFile.
	self assert: (root / 'models.json') isFile.
	self assert: (root / 'models') isDirectory.
	self assert: (root / '.history' / 'models') isDirectory
]

{ #category : #tests }
OPProjectPersistenceTest >> testDeleteOldModels [
	| models folder |
	folder := FileSystem memory root / 'models'.
	models := {(OPTestEntityModel new uuid: UUID new).
	OPTestEntityModel new}.
	persistence
		saveMemento: (OPPersistenceMemento model: models first diagram: nil)
		to: folder
		with: OPStonSerializer new.
	persistence
		saveMemento: (OPPersistenceMemento model: models second diagram: nil)
		to: folder
		with: OPStonSerializer new.
	self assert: folder children size equals: 2.
	persistence removeModelsNotIn: models allButLast from: folder.
	self assert: folder children size equals: 1.
	self
		assert: folder children anyOne basename
		equals: models first uuid asString
]

{ #category : #tests }
OPProjectPersistenceTest >> testExporterVersion [
	self assert: persistence exporter equals: 'OpenPonk'.
	self assert: persistence exporterVersion equals: OPVersion version
]

{ #category : #tests }
OPProjectPersistenceTest >> testModelReferences [
	| result models |
	models := OPPluginRegistry default plugins collect: [ :each | each modelClass new ].
	result := STON fromString: (String streamContents: [ :stream | stream << (persistence modelReferencesToJson: models) ]).
	self assert: result size equals: models size.
	self assert: (result collect: [ :each | each at: #plugin ]) asSet equals: (OPPluginRegistry default plugins collect: #className) asSet
]

{ #category : #tests }
OPProjectPersistenceTest >> testNoDiagramOverride [
	| model folder memento contents |
	folder := FileSystem memory root / 'models'.
	model := OPTestEntityModel new.
	memento := OPPersistenceMemento model: model diagram: {(#Item -> 1)} asDictionary.
	persistence saveMemento: memento to: folder with: OPStonSerializer new.
	contents := (folder / memento uuid asString / 'diagram.ston') contents.
	memento := OPPersistenceMemento model: model diagram: nil.
	persistence saveMemento: memento to: folder with: OPStonSerializer new.
	self assert: (folder / memento uuid asString / 'diagram.ston') contents equals: contents
]

{ #category : #tests }
OPProjectPersistenceTest >> testNoModelReferences [
	| result |
	result := String
		streamContents: [ :stream | stream << (persistence modelReferencesToJson: #()) ].
	self assert: (STON fromString: result) equals: #()
]

{ #category : #tests }
OPProjectPersistenceTest >> testProjectFile [
	| result resultString |
	resultString := String
		streamContents: [ :stream | 
			stream
				<<
					(persistence
						projectToJson:
							(OPProject new
								name: 'My Project';
								uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c'))) ].
	result := STON fromString: resultString.
	(result at: 'exporter') at: 'timestamp' put: '0'.
	self
		assert: result
		equals:
			{'project'
				->
					{'name' -> 'My Project'.
					'uuid' -> '7f5ee44a-1655-4061-a78e-db9578a2226c'} asDictionary.
			'exporter'
				->
					{'exporter' -> 'OpenPonk'.
					'exporterVersion' -> OPVersion version.
					'timestamp' -> '0'} asDictionary} asDictionary
]

{ #category : #tests }
OPProjectPersistenceTest >> testRoundtrip [
	| folder memento |
	folder := FileSystem memory root / 'models'.
	folder ensureCreateDirectory.
	memento := OPPersistenceMemento
		model: OPTestEntityModel new
		diagram: {#Item -> 1} asDictionary.
	persistence saveMemento: memento to: folder with: OPStonSerializer new.
	self assert: (folder / memento uuid asString) isDirectory.
	self
		assert: (folder / memento uuid asString / 'model.ston') contents
		equals: (STON toStringPretty: memento model).
	self
		assert: (folder / memento uuid asString / 'diagram.ston') contents
		equals: (STON toStringPretty: memento diagram)
]
