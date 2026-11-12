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
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
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

	self deny: project equals: nil.
	self deny: project equals: 'not a project'.
	self deny: project equals: [ 1 ]
]

{ #category : 'tests' }
OPProjectTest >> testMergeWithAndCopyDiagramAndStorage [
	| otherProject otherModel otherDiagram copiedDiagram tempFolder |
	project := OPProject name: 'Primary Project'.
	self assert: project name equals: 'Primary Project'.
	self assert: project hash equals: project uuid hash.
	self assert: project descriptionName label equals: 'Name'.
	project addModel: model.
	project ensureModelsHaveDiagrams.
	copiedDiagram := project copyDiagram: project diagrams first.
	self assert: project diagrams size equals: 2.
	self deny: copiedDiagram identicalTo: project diagrams first.
	otherProject := OPProject name: 'Secondary Project'.
	otherModel := OPTestContainerModel new name: 'OtherContainer'; yourself.
	otherDiagram := OPOpenPonkDiagram forModelElement: otherModel.
	otherProject addDiagram: otherDiagram.
	project mergeWith: otherProject.
	self assertEmpty: otherProject models.
	self assertCollection: project models includesAll: { model . otherModel }.
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
			description: 'removeFromImage should remove project from OPProjectStorage default'
	] ensure: [ project removeFromImage ]
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
