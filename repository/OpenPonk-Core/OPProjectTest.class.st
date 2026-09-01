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
