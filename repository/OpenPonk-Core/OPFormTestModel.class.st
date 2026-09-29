"
Mock domain model used exclusively for testing dynamic form field bindings and undo/redo synchronization.
"
Class {
	#name : 'OPFormTestModel',
	#superclass : 'Object',
	#instVars : [
		'uuid',
		'name',
		'isActive',
		'category'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'as yet unclassified' }
OPFormTestModel >> category [ ^ category
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> category: aSymbol [ category := aSymbol
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> initialize [
	super initialize.
	uuid := UUID new.
	name := 'Initial'.
	isActive := false.
	category := #alpha
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> isActive [ ^ isActive
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> isActive: aBoolean [ isActive := aBoolean
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> name [ ^ name
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> name: aString [ name := aString
]

{ #category : 'as yet unclassified' }
OPFormTestModel >> uuid [ ^ uuid
]
