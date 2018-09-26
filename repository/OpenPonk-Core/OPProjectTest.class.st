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
	self assert: project views isEmpty.
	model := OPTestContainerModel new.
	project addModel: model.
	self assert: project models asArray equals: {model}.
	self assert: project views size equals: 1.
	view := project views first.
	self assert: view isDefault.
	self assert: view model equals: model
]

{ #category : #tests }
OPProjectTest >> testChangedOnAdd [
	| project diagram changed element |
	true
		ifTrue: [ self skip: 'CI has strange issues with announcements.' ].
	changed := false.
	project := OPProject new.
	project whenChanged: [ changed := true ].
	self deny: changed.

	changed := false.
	project projectName: 'Project name'.
	self assert: changed.

	changed := false.
	diagram := OPDiagram new.
	project addModel: diagram.
	self assert: changed.

	changed := false.
	element := OPNamedElement new.
	diagram add: element.
	self assert: changed.

	changed := false.
	element name: 'a name'.
	self assert: changed
]

{ #category : #tests }
OPProjectTest >> testChangedOnRemove [
	| project diagram changed element |
	true
		ifTrue: [ self skip: 'CI has strange issues with announcements.' ].
	project := OPProject new.
	diagram := OPDiagram new.
	element := OPNamedElement new.
	project whenChanged: [ changed := true ].
	project addModel: diagram.
	diagram add: element.

	changed := false.
	project removeModel: diagram.
	self assert: changed.

	changed := false.
	diagram name: 'new name'.
	self deny: changed.

	changed := false.
	element name: 'changed'.
	self deny: changed
]

{ #category : #tests }
OPProjectTest >> testRemoveModel [
	project := OPProject new.
	model := OPTestContainerModel new.
	project addModel: model.
	self assert: project views size equals: 1.
	project removeModel: model.
	self assert: project models isEmpty.
	self assert: project views isEmpty
]
