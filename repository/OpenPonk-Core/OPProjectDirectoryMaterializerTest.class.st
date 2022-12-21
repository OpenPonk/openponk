Class {
	#name : #OPProjectDirectoryMaterializerTest,
	#superclass : #TestCase,
	#instVars : [
		'reader',
		'root',
		'project',
		'memoryRoot'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #running }
OPProjectDirectoryMaterializerTest >> setUp [
	super setUp.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new).
	reader := OPProjectDirectoryMaterializer new.
	self setUpBasicProject
]

{ #category : #'instance creation' }
OPProjectDirectoryMaterializerTest >> setUpBasicProject [
	(project := OPProject new)
		name: 'Test Project';
		uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c').
	memoryRoot := FileSystem memory / 'test-project'.
	project addModel: OPTestContainerModel new.
	OPProjectController new
		project: project;
		workbench: OPWorkbench new;
		saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open / 'project'
]

{ #category : #running }
OPProjectDirectoryMaterializerTest >> tearDown [
	OPPluginRegistry resetDefault
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testMissingProject [
	self should: [ reader loadProjectFrom: FileSystem memory root ] raise: FileDoesNotExistException
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testPluginReferenceKnown [
	self
		assert: {reader pluginForName: #OPTestPlugin pluginVersion: OPTestPlugin new version}
		equals: OPPluginRegistry default plugins asArray
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testPluginReferenceUnknown [
	self
		should: [ reader pluginForName: 'Unknown' pluginVersion: '0.0.0' ]
		raise: Error
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testRead [
	self assert: (reader loadProjectFrom: root) models size equals: 1
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testReadMemento [

	| memento |
	memento := reader
		           readMementoFrom:
		           root / 'models' / project models first uuid asString
		           with: (OPMementoDirectorySerializer
				            withModelSerializer: OPStonModelSerializer new
				            diagramsSerializer: OPJsonDiagramSerializer new).
	self
		assert: memento model className
		equals: project models first className.
	self assert: memento model name equals: project models first name.
	self assert: memento model uuid equals: project models first uuid.
	self assert: memento diagrams isEmpty
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testReadMementos [
	self assert: (reader readAllMementosFrom: root) size equals: 1
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testReadModelReferences [
	| references |
	references := reader readModelReferences: root.
	self
		assert: references first
		equals: project models first uuid -> OPPluginRegistry default plugins first
]

{ #category : #tests }
OPProjectDirectoryMaterializerTest >> testReadProject [
	project := reader readProjectInfoFrom: root / 'project.json'.
	self assert: project name equals: 'Test Project'.
	self
		assert: project uuid
		equals: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c')
]

{ #category : #running }
OPProjectDirectoryMaterializerTest >> testSetUp [
	self assert: (root / 'project.json') exists
]
