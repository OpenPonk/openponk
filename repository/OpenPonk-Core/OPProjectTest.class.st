Class {
	#name : #OPProjectTest,
	#superclass : #TestCase,
	#instVars : [
		'project',
		'model'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #tests }
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

{ #category : #tests }
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
