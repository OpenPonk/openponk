Class {
	#name : #OPPersistenceProjectReaderTest,
	#superclass : #TestCase,
	#instVars : [
		'reader',
		'root',
		'project',
		'memoryRoot'
	],
	#category : 'OpenPonk-Core-Tests'
}

{ #category : #running }
OPPersistenceProjectReaderTest >> setUp [
	super setUp.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new).
	reader := OPPersistenceProjectReader new.
	self setUpBasicProject
]

{ #category : #'instance creation' }
OPPersistenceProjectReaderTest >> setUpBasicProject [
	(project := OPProject new)
		name: 'Test Project';
		uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c').
	memoryRoot := FileSystem memory / 'test-project'.
	project addModel: OPTestContainerModel new.
	OPProjectController new
		project: project;
		saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open
]

{ #category : #running }
OPPersistenceProjectReaderTest >> tearDown [
	OPPluginRegistry resetDefault
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testExporterVersion [
	self assert: reader exporter equals: 'OpenPonk'.
	self assert: reader exporterVersion equals: OPVersion version
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testMissingProject [
	self should: [ reader fromFolder: FileSystem memory root ] raise: FileDoesNotExist
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testPluginReferenceKnown [
	self
		assert: {reader pluginForName: #OPTestPlugin pluginVersion: OPTestPlugin new version}
		equals: OPPluginRegistry default plugins asArray
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testPluginReferenceUnknown [
	self
		should: [ reader pluginForName: 'Unknown' pluginVersion: '0.0.0' ]
		raise: Error
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testRead [
	self assert: (reader fromFolder: root) models size equals: 1
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testReadMemento [
	| memento |
	memento := reader
		readMementoFrom: root / 'models' / project models first uuid asString
		with: OPStonSerializer new.
	self assert: memento model className equals: project models first className.
	self assert: memento model name equals: project models first name.
	self assert: memento model uuid equals: project models first uuid.
	self assert: memento diagram equals: nil
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testReadMementos [
	self assert: (reader readAllMementosFrom: root) size equals: 1
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testReadModelReferences [
	| references |
	references := reader readModelReferences: root.
	self
		assert: references first
		equals: project models first uuid -> OPPluginRegistry default plugins first
]

{ #category : #tests }
OPPersistenceProjectReaderTest >> testReadProject [
	project := reader readProjectFrom: root / 'project.json'.
	self assert: project name equals: 'Test Project'.
	self
		assert: project uuid
		equals: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c')
]

{ #category : #running }
OPPersistenceProjectReaderTest >> testSetUp [
	self assert: (root / 'project.json') exists
]
