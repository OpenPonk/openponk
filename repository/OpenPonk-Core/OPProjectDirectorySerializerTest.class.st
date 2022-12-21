Class {
	#name : #OPProjectDirectorySerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'persistence'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #running }
OPProjectDirectorySerializerTest >> setUp [
	super setUp.
	persistence := OPProjectDirectorySerializer new.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new)
]

{ #category : #running }
OPProjectDirectorySerializerTest >> tearDown [
	OPPluginRegistry resetDefault
]

{ #category : #tests }
OPProjectDirectorySerializerTest >> testCreateFolderStructure [
	| root |
	root := FileSystem memory root / 'project'.
	persistence directory: root.
	persistence saveProject: OPProject new.
	self assert: root isDirectory.
	self assert: (root / 'project.json') isFile.
	self assert: (root / 'models.json') isFile.
	self assert: (root / 'models') isDirectory.
	self assert: (root / '.history' / 'models') isDirectory
]

{ #category : #tests }
OPProjectDirectorySerializerTest >> testDeleteOldModels [
	| models folder modelsFolder |
	folder := FileSystem memory root.
	modelsFolder := folder / 'models'.
	models := {(OPTestEntityModel new uuid: UUID new).
	OPTestEntityModel new}.
	persistence directory: folder.
	persistence
		saveMemento: (OPPersistenceMemento model: models first diagrams: #())
		with: OPStonSerializer new.
	persistence
		saveMemento: (OPPersistenceMemento model: models second diagrams: #())
		with: OPStonSerializer new.
	self assert: modelsFolder children size equals: 2.
	persistence removeModelsNotIn: models allButLast.
	self assert: modelsFolder children size equals: 1.
	self
		assert: modelsFolder children anyOne basename
		equals: models first uuid asString , '.ston'
]

{ #category : #tests }
OPProjectDirectorySerializerTest >> testModelReferences [
	| result models |
	models := OPPluginRegistry default plugins collect: [ :each | each modelClass new ].
	result := STON fromString: (String streamContents: [ :stream | stream << (persistence modelReferencesToJson: models) ]).
	self assert: result size equals: models size.
	self assert: (result collect: [ :each | each at: #plugin ]) asSet equals: (OPPluginRegistry default plugins collect: #className) asSet
]

{ #category : #tests }
OPProjectDirectorySerializerTest >> testNoModelReferences [
	| result |
	result := String
		streamContents: [ :stream | stream << (persistence modelReferencesToJson: #()) ].
	self assert: (STON fromString: result) equals: #()
]

{ #category : #tests }
OPProjectDirectorySerializerTest >> testProjectFile [
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
			{('project'
				->
					{('name' -> 'My Project').
					('uuid' -> '7f5ee44a-1655-4061-a78e-db9578a2226c')} asDictionary).
			('exporter'
				->
					{('exporter' -> 'OpenPonk').
					('exporterVersion' -> OPVersion current fullVersionString).
					('timestamp' -> '0')} asDictionary)} asDictionary
]
