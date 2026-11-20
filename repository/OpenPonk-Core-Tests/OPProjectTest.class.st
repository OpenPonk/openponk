"
Unit tests for OPProject. 
Verifies the basic structural integrity of a project, including tracking of domain models and their associated diagrams.
"
Class {
	#name : 'OPProjectTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'model'
	],
	#category : 'OpenPonk-Core-Tests-Models',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Models'
}

{ #category : 'running' }
OPProjectTest >> setUp [

	super setUp.
	project := OPProject new.
	model := OPTestContainerModel new
]

{ #category : 'tests' }
OPProjectTest >> testAddModel [

	| diagram |
	self assertEmpty: project models.
	self assertEmpty: project diagrams.
	project addModel: model.
	self assert: project models asArray equals: { model }.
	project ensureModelsHaveDiagrams.
	self assert: project diagrams size equals: 1.
	diagram := project diagrams first.
	self assert: diagram modelElement equals: model
]

{ #category : 'tests' }
OPProjectTest >> testCopyDiagramNamed [

	| originalDiagram copiedDiagram |
	project addModel: model.
	project ensureModelsHaveDiagrams.
	originalDiagram := project diagrams first.
	originalDiagram name: 'Original Diagram'.

	copiedDiagram := project copyDiagram: originalDiagram named: 'Copied Diagram'.

	self assert: copiedDiagram name equals: 'Copied Diagram'.
	self assertCollection: project diagrams includesAll: { copiedDiagram }.
	self assert: project diagrams size equals: 2.
	self deny: copiedDiagram identicalTo: originalDiagram
]

{ #category : 'tests' }
OPProjectTest >> testEqualityWithNonProjectReturnsFalse [

	self deny: project = nil description: 'OPProject>>#= must return false when compared with nil'.
	self deny: project equals: 'not a project'.
	self deny: project equals: [ 1 ]
]

{ #category : 'tests' }
OPProjectTest >> testMementoAndRemovalDescriptor [
	| model diag memento1 memento2 node descriptor |
	model := OPTestContainerModel new.
	model instVarNamed: #uuid put: UUID new.
	diag := OPOpenPonkDiagram forModelElement: model.
	memento1 := OPMemento model: model diagrams: { diag }.
	memento2 := OPMemento model: model diagrams: { diag }.
	self assert: memento1 equals: memento2.
	self assert: memento1 uuid equals: model uuid.
	self assert: memento1 model identicalTo: model.
	self assertCollection: memento1 diagrams hasSameElements: { diag }.

	node := OPTestBoundNode new.
	node owningElement: diag.
	node bounds: (OPNodeBounds withPosition: 40 @ 60 extent: 80 @ 50).
	descriptor := OPDiagramElementRemovalDescriptor new.
	descriptor diagram: diag.
	descriptor captureFrom: node.
	self assert: descriptor diagram identicalTo: diag.
	self assert: descriptor diagramElement identicalTo: node.
	self assert: descriptor owningElement identicalTo: diag.
	self assert: descriptor geometryMemento position equals: 40 @ 60.

	node owningElement: nil.
	node bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 10 @ 10).
	descriptor restoreDiagramElement.
	self assert: node owningElement identicalTo: diag.
	self assert: node bounds position equals: 40 @ 60
]

{ #category : 'tests' }
OPProjectTest >> testMergeWithAndCopyDiagramAndStorage [

	| otherProject otherModel otherDiagram copiedDiagram tempFolder |
	project := OPProject named: 'Primary Project'.
	self assert: project name equals: 'Primary Project'.
	self assert: project hash equals: project uuid hash.
	self assert: project descriptionName label equals: 'Name'.
	project addModel: model.
	project ensureModelsHaveDiagrams.
	copiedDiagram := project copyDiagram: project diagrams first.
	self assert: project diagrams size equals: 2.
	self deny: copiedDiagram identicalTo: project diagrams first.
	otherProject := OPProject named: 'Secondary Project'.
	otherModel := OPTestContainerModel new
		              name: 'OtherContainer';
		              yourself.
	otherDiagram := OPOpenPonkDiagram forModelElement: otherModel.
	otherProject addDiagram: otherDiagram.
	project mergeWith: otherProject.
	self assertEmpty: otherProject models.
	self assertCollection: project models includesAll: {
			model.
			otherModel }.
	self assertCollection: project diagrams includesAll: { otherDiagram }.
	project diagrams: { copiedDiagram }.
	self assert: project diagrams asArray equals: { copiedDiagram }.
	tempFolder := FileSystem memory root / 'proj-folder'.
	project storageFolder: tempFolder.
	self assert: project storageFolder equals: tempFolder.
	[
		project saveInImage.
		self
			assert: (OPProjectStorage default projects includes: project)
			description: 'saveInImage should register project in OPProjectStorage default'.
		project removeFromImage.
		self
			deny: (OPProjectStorage default projects includes: project)
			description: 'removeFromImage should remove project from OPProjectStorage default' ] ensure: [ project removeFromImage ]
]

{ #category : 'tests' }
OPProjectTest >> testModelsAndDiagramsHasDiagramsModelProjectCallbackAndInspectionItems [

	| projectAwareModel builder tree absentModel |
	self deny: (project hasDiagramsModel: model) description: 'Project without model must report hasDiagramsModel: false'.
	projectAwareModel := OPRenameProjectCommand new.
	project addModel: projectAwareModel.
	self assert: projectAwareModel project identicalTo: project.
	self
		assert: (project modelsAndDiagrams includesKey: projectAwareModel)
		description: 'modelsAndDiagrams should include added model'.
	project removeModel: projectAwareModel.
	self assert: projectAwareModel project identicalTo: nil.

	project addModel: model.
	project ensureModelsHaveDiagrams.
	builder := SpPresenter newApplication: SpApplication defaultApplication.
	tree := project inspectionItems: builder.
	self assertCollection: tree roots hasSameElements: { model }.
	self assert: (tree children value: model) size equals: 1.
	absentModel := OPTestContainerModel new.
	absentModel instVarNamed: #uuid put: UUID new.
	self assertEmpty: (tree children value: absentModel)
]

{ #category : 'tests' }
OPProjectTest >> testRemoveModel [

	project addModel: model.
	project ensureModelsHaveDiagrams.
	self assert: project diagrams size equals: 1.
	project removeModel: model.
	self assertEmpty: project models.
	self assertEmpty: project diagrams
]
