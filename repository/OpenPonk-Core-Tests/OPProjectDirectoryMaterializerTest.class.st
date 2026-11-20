"
Unit tests for OPProjectDirectoryMaterializer. 
Verifies the reconstruction of a full OPProject, alongside its diagrams and mementos, from a structured directory source.
"
Class {
	#name : 'OPProjectDirectoryMaterializerTest',
	#superclass : 'TestCase',
	#instVars : [
		'reader',
		'root',
		'project',
		'memoryRoot'
	],
	#category : 'OpenPonk-Core-Tests-Persistence',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Persistence'
}

{ #category : 'running' }
OPProjectDirectoryMaterializerTest >> setUp [

	super setUp.
	OPPluginRegistry setDefaultForTesting.
	reader := OPProjectDirectoryMaterializer new.
	self setUpBasicProject
]

{ #category : 'running' }
OPProjectDirectoryMaterializerTest >> setUpBasicProject [
	(project := OPProject new)
		name: 'Test Project';
		uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c').
	memoryRoot := FileSystem memory / 'test-project'.
	project addModel: OPTestContainerModel new.
	(OPProjectController forProject: project)
		saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open / 'project'
]

{ #category : 'running' }
OPProjectDirectoryMaterializerTest >> tearDown [

	OPPluginRegistry resetDefault.
	super tearDown
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testExportVersionAndModelIdFrom [

	self assert: OPProjectDirectoryMaterializer exportVersion equals: 0.
	self assert: (reader modelIdFrom: '42') equals: 42.
	self assert: (reader modelIdFrom: 'custom-model-id') equals: 'custom-model-id'
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testForExportInfoSelectsHighestMaxThenHighestMinVersion [

	| v1Info v2Info selectedForV1 selectedForV2 |
	v1Info := OPExportInfo new
		          subject: #testSubject;
		          format: #testFormat;
		          version: 1;
		          yourself.
	v2Info := OPExportInfo new
		          subject: #testSubject;
		          format: #testFormat;
		          version: 2;
		          yourself.
	self
		assert: (OPTestSerializerV1 supportsExportInfo: v1Info)
		description: 'Version 1 test serializer should support version 1 export info'.
	selectedForV1 := OPSerializer forExportInfo: v1Info.
	selectedForV2 := OPSerializer forExportInfo: v2Info.
	self assert: selectedForV1 class identicalTo: OPTestSerializerV2Wide.
	self assert: selectedForV2 class identicalTo: OPTestSerializerV2Narrow
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testMementoDirectorySerializerLegacyModelLayoutJsonDiagramsAndEmptyName [

	| folder diagramsFolder container entity mementoSerializer memento unnamedDiagram |
	container := OPTestContainerModel new.
	container instVarNamed: #uuid put: UUID new.
	entity := OPTestEntityModel new.
	entity instVarNamed: #uuid put: UUID new.
	container add: entity.

	folder := FileSystem memory / 'legacy-memento-folder'.
	folder ensureCreateDirectory.
	folder / 'model.ston' writeStreamDo: [ :stream | OPStonModelSerializer new serializeModel: container to: stream ].
	diagramsFolder := folder / 'diagrams'.
	diagramsFolder ensureCreateDirectory.
	diagramsFolder / '1-main.json' writeStreamDo: [ :stream |
			stream
				nextPutAll: '{"name":"LegacyJson","isOpen":false,"isSelected":false,"camera":{"offset":{"x":0,"y":0},"zoom":1.0},"layout":{"';
				nextPutAll: entity uuid asString;
				nextPutAll: '":{"position":{"x":10,"y":20},"extent":{"x":30,"y":40}}},"visibleElements":["';
				nextPutAll: entity uuid asString;
				nextPutAll: '"]}' ].

	mementoSerializer := OPMementoDirectorySerializer forPlugin: OPTestPlugin new.
	memento := mementoSerializer loadMementoFrom: folder.
	self assert: memento model uuid equals: container uuid.
	self assert: memento diagrams size equals: 1.
	self assert: memento diagrams first name equals: 'LegacyJson'.

	unnamedDiagram := OPOpenPonkDiagram forModelElement: container.
	unnamedDiagram name: ''.
	mementoSerializer saveDiagram: unnamedDiagram to: diagramsFolder index: 2.
	self
		assert: (diagramsFolder / '2-diagram.ston') isFile
		description: 'Diagram with empty name should default to index-diagram.ston'
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testMissingProject [
	self should: [ reader loadProjectFrom: FileSystem memory root ] raise: FileDoesNotExistException
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testNoModelFound [
	| emptyFolder serializer |
	emptyFolder := FileSystem memory / 'empty-model-folder'.
	emptyFolder ensureCreateDirectory.
	serializer := OPMementoDirectorySerializer forPlugin: OPTestPlugin new.
	self
		should: [ serializer loadModelFrom: emptyFolder ]
		raise: OPNoModelFound
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testPluginReferenceKnown [
	self
		assert: {reader pluginForName: #OPTestPlugin pluginVersion: OPTestPlugin new version}
		equals: OPPluginRegistry default plugins asArray
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testPluginReferenceUnknown [
	self
		should: [ reader pluginForName: 'Unknown' pluginVersion: '0.0.0' ]
		raise: OPUnknownPlugin
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testRead [
	self assert: (reader loadProjectFrom: root) models size equals: 1
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testReadMemento [

	| memento |
	memento := reader readMementoFrom: root / 'models' / project models first uuid asString asPlugin: OPTestPlugin new.
	self assert: memento model className equals: project models first className.
	self assert: memento model name equals: project models first name.
	self assert: memento model uuid equals: project models first uuid.
	self assertEmpty: memento diagrams
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testReadMementoWithoutExportInfoAndEmptyResult [

	| folderNoExportInfo modelFile memento pluginReturningNil emptySerializer |
	folderNoExportInfo := FileSystem memory / 'memento-no-export-info'.
	folderNoExportInfo ensureCreateDirectory.
	modelFile := folderNoExportInfo / 'model.ston'.
	modelFile writeStreamDo: [ :stream | OPStonModelSerializer new serializeModel: OPTestContainerModel new to: stream ].
	memento := reader readMementoFrom: folderNoExportInfo asPlugin: OPTestPlugin new.
	self assert: memento model class identicalTo: OPTestContainerModel.
	self assertEmpty: memento diagrams.

	emptySerializer := Mock new.
	(emptySerializer stub loadMementoFrom: folderNoExportInfo) willReturn: nil.
	pluginReturningNil := Mock new.
	pluginReturningNil stub serializer willReturn: emptySerializer.
	self should: [ reader readMementoFrom: folderNoExportInfo asPlugin: pluginReturningNil ] raise: OPSerializationWithEmptyResult
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testReadMementos [
	self assert: (reader readAllMementosFrom: root) size equals: 1
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testReadModelReferences [
	| references |
	references := reader readModelReferences: root.
	self
		assert: references first
		equals: project models first uuid -> OPPluginRegistry default plugins first
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testReadProject [
	project := reader readProjectInfoFrom: root / 'project.json'.
	self assert: project name equals: 'Test Project'.
	self
		assert: project uuid
		equals: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c')
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testReadProjectInfoLegacyExporterKey [

	| legacyProjectFile loadedProject |
	legacyProjectFile := FileSystem memory / 'legacy-project.json'.
	legacyProjectFile writeStreamDo: [ :stream |
			stream nextPutAll:
				'{"exporter":{"exporter":"OpenPonk"},"project":{"name":"Legacy Name","uuid":"7f5ee44a-1655-4061-a78e-db9578a2226c"}}' ].
	loadedProject := reader readProjectInfoFrom: legacyProjectFile.
	self assert: loadedProject name equals: 'Legacy Name'.
	self assert: loadedProject uuid equals: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c')
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testSetUp [
	self
		assert: (root / 'project.json') exists
		description: 'Materializer test fixture should create project.json in root folder'
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testUnsupportedExportInfo [
	| unsupportedInfo |
	unsupportedInfo := OPExportInfo new
		subject: #unknownSubject;
		version: 999;
		format: #unknownFormat;
		yourself.
	self
		should: [ OPSerializer forExportInfo: unsupportedInfo ]
		raise: OPUnsupportedSerializer
]

{ #category : 'tests' }
OPProjectDirectoryMaterializerTest >> testUnsupportedExporter [
	| invalidProjectFile |
	invalidProjectFile := FileSystem memory / 'invalid-project.json'.
	invalidProjectFile writeStreamDo: [ :stream |
		stream nextPutAll: '{"export":{"exporter":"OtherTool"},"project":{"name":"Test","uuid":"7f5ee44a-1655-4061-a78e-db9578a2226c"}}' ].
	self
		should: [ reader readProjectInfoFrom: invalidProjectFile ]
		raise: OPUnsupportedSerializer
]
