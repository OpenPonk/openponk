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
OPProjectTest >> testRemoveModel [

	project addModel: model.
	project ensureModelsHaveDiagrams.
	self assert: project diagrams size equals: 1.
	project removeModel: model.
	self assertEmpty: project models.
	self assertEmpty: project diagrams
]
