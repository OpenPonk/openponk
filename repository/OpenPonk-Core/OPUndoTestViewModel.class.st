"
Mock domain target used by undo/redo unit tests.
"
Class {
	#name : 'OPUndoTestViewModel',
	#superclass : 'Object',
	#instVars : [
		'name',
		'description',
		'value',
		'log'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'accessing' }
OPUndoTestViewModel >> description [
	^ description
]

{ #category : 'accessing' }
OPUndoTestViewModel >> description: aString [
	description := aString
]

{ #category : 'initialization' }
OPUndoTestViewModel >> initialize [
	super initialize.
	log := OrderedCollection new.
	value := 0
]

{ #category : 'accessing' }
OPUndoTestViewModel >> log [
	^ log
]

{ #category : 'accessing' }
OPUndoTestViewModel >> name [
	^ name
]

{ #category : 'accessing' }
OPUndoTestViewModel >> name: aString [
	name := aString
]

{ #category : 'properties' }
OPUndoTestViewModel >> propertyNamed: aSymbol put: aValue [
	"Mutate the target property. Dispatches form rebuild for structural properties and modelChanged for standard value updates."

	| mutator |
	aSymbol ifNil: [ ^ self ].
	mutator := (aSymbol endsWith: ':')
		           ifTrue: [ aSymbol asSymbol ]
		           ifFalse: [ (aSymbol , ':') asSymbol ].
	self perform: mutator with: aValue
]

{ #category : 'evaluating' }
OPUndoTestViewModel >> value [
	^ value
]

{ #category : 'accessing' }
OPUndoTestViewModel >> value: aNumber [
	value := aNumber
]
