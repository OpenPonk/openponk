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
	| view |
	project := OPProject new.
	self assert: project models isEmpty.
	self assert: project diagrams isEmpty.
	model := OPTestContainerModel new.
	project addModel: model.
	self assert: project models asArray equals: {model}.
	project ensureModelsHaveDiagrams.
	self assert: project diagrams size equals: 1.
	view := project diagrams first.
	view visibleElements ifEmpty: [ self assert: false ].
	self assert: view model equals: model
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
