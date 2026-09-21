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

{ #category : 'tests' }
OPProjectTest >> testAddModel [

	| diagram visibleElements |
	project := OPProject new.
	self assert: project models isEmpty.
	self assert: project diagrams isEmpty.
	model := OPTestContainerModel new.
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
	project := OPProject new.
	model := OPTestContainerModel new.
	project addModel: model.
	project ensureModelsHaveDiagrams.
	originalDiagram := project diagrams first.
	originalDiagram name: 'Original Diagram'.

	copiedDiagram := project copyDiagram: originalDiagram named: 'Copied Diagram'.

	self assert: copiedDiagram name equals: 'Copied Diagram'.
	self assert: (project diagrams includes: copiedDiagram).
	self assert: project diagrams size equals: 2.
	self deny: copiedDiagram identicalTo: originalDiagram
]

{ #category : 'tests' }
OPProjectTest >> testRemoveModel [
	project := OPProject new.
	model := OPTestContainerModel new.
	project addModel: model.
	project ensureModelsHaveDiagrams.
	self assert: project diagrams size equals: 1.
	project removeModel: model.
	self assert: project models isEmpty.
	self assert: project diagrams isEmpty
]
