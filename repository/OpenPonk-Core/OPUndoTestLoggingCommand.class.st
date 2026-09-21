"
Test command that records execution traces to an OrderedCollection to verify FIFO/LIFO sequences.
"
Class {
	#name : 'OPUndoTestLoggingCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'log',
		'value'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'as yet unclassified' }
OPUndoTestLoggingCommand class >> log: anOrderedCollection value: anObject [
	^ self new
		log: anOrderedCollection;
		value: anObject;
		yourself
]

{ #category : 'executing' }
OPUndoTestLoggingCommand >> execute [
	log add: ('execute:' , value asString)
]

{ #category : 'accessing' }
OPUndoTestLoggingCommand >> log: anOrderedCollection [
	log := anOrderedCollection
]

{ #category : 'executing' }
OPUndoTestLoggingCommand >> redo [
	log add: ('redo:' , value asString)
]

{ #category : 'executing' }
OPUndoTestLoggingCommand >> undo [ log add: ('undo:' , value asString)
]

{ #category : 'accessing' }
OPUndoTestLoggingCommand >> value: anObject [
	value := anObject
]
