Class {
	#name : 'OPExamplePersistenceTest',
	#superclass : 'TestCase',
	#instVars : [
		'file',
		'sourceWorkbench',
		'targetWorkbench'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPExamplePersistenceTest class >> isAbstract [

	^ self = OPExamplePersistenceTest
]

{ #category : 'hooks' }
OPExamplePersistenceTest >> createExampleModel [

	^ self subclassResponsibility
]

{ #category : 'running' }
OPExamplePersistenceTest >> setUp [

	super setUp.
	file := FileSystem memory root / 'example-persistence-test.opp'.
	file ensureDelete
]

{ #category : 'running' }
OPExamplePersistenceTest >> tearDown [

	sourceWorkbench ifNotNil: [ :workbench |
		workbench application closeAllWindows.
		sourceWorkbench := nil ].
	targetWorkbench ifNotNil: [ :workbench |
		workbench application closeAllWindows.
		targetWorkbench := nil ].
	file ifNotNil: [
		file ensureDelete.
		file := nil ].
	Smalltalk garbageCollect.
	super tearDown
]

{ #category : 'tests' }
OPExamplePersistenceTest >> testSaveAndLoad [

	| sourceModel sourceProject sourceEditor sourceCanvas sourceProjectController sourceShapes targetProject targetEditor targetCanvas targetShapes |
	sourceModel := self createExampleModel.
	sourceProject := OPProject new
		                 name: 'TestProject';
		                 addModel: sourceModel;
		                 yourself.
	sourceWorkbench := sourceProject open.
	sourceWorkbench showAllElementsInAllDiagrams.
	sourceEditor := sourceWorkbench focusedEditor.
	sourceCanvas := sourceEditor canvasPresenter canvas.
	sourceShapes := sourceCanvas shapes
		                collect: [ :each | each class ]
		                as: Bag.
	self denyCollection: sourceShapes equals: Bag empty.
	sourceProjectController := sourceWorkbench projectController.
	sourceProjectController saveProjectTo: file.

	targetProject := OPProjectController fromFile: file.
	targetWorkbench := targetProject open.
	targetWorkbench showAllElementsInAllDiagrams.
	targetEditor := targetWorkbench focusedEditor.
	targetCanvas := targetEditor canvasPresenter canvas.
	targetShapes := targetCanvas shapes
		                collect: [ :each | each class ]
		                as: Bag.
	self assertCollection: targetShapes equals: sourceShapes
]
