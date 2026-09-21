"
Manages undo and redo histories for an OPProjectController. Coordinates command recording, history limits, isolated nested transactions, exception rollbacks, and reentrancy protection.
"
Class {
	#name : 'OPUndoManager',
	#superclass : 'Object',
	#instVars : [
		'undoStack',
		'redoStack',
		'maxUndoSteps',
		'isExecutingUndoRedo',
		'transactionStack',
		'announcer'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'constants' }
OPUndoManager class >> defaultMaxUndoSteps [
	"Answer the default limit for undo steps in history."
	^ 100
]

{ #category : 'as yet unclassified' }
OPUndoManager >> announceChanged [
	self announcer announce: OPUndoRedoChanged new
]

{ #category : 'accessing' }
OPUndoManager >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'testing' }
OPUndoManager >> canRedo [
	"Answer whether redo can currently be initiated."
	^ redoStack isNotEmpty and: [ self isInTransaction not and: [ self isExecutingUndoRedo not ] ]
]

{ #category : 'testing' }
OPUndoManager >> canUndo [
	"Answer whether undo can currently be initiated."
	^ undoStack isNotEmpty and: [ self isInTransaction not and: [ self isExecutingUndoRedo not ] ]
]

{ #category : 'accessing' }
OPUndoManager >> clear [
	"Purge all history stacks and transactions."
	undoStack removeAll.
	redoStack removeAll.
	transactionStack removeAll.
	isExecutingUndoRedo := false.
	self announceChanged
]

{ #category : 'as yet unclassified' }
OPUndoManager >> enforceMaxUndoSteps [
	"Discard the oldest steps exceeding maxUndoSteps."
	[ undoStack size > maxUndoSteps ] whileTrue: [
		undoStack removeFirst ]
]

{ #category : 'public' }
OPUndoManager >> execute: aCommand [
	"Execute aCommand and record it into history in a single atomic step."
	aCommand execute.
	self record: aCommand
]

{ #category : 'undo/redo' }
OPUndoManager >> inTransaction: aBlockClosure [
	"Group all recorded actions within aBlockClosure into a single composite command."
	^ self inTransactionLabeled: nil do: aBlockClosure
]

{ #category : 'undo/redo' }
OPUndoManager >> inTransactionLabeled: aString do: aBlockClosure [
	"Group all recorded actions within aBlockClosure into a single composite command with an optional explicit label."
	| transaction isSuccess |
	transaction := OPCompositeCommand new.
	aString ifNotNil: [ transaction description: aString ].
	transactionStack addLast: transaction.
	isSuccess := false.
	^ [
		| result |
		result := aBlockClosure cull: transaction.
		isSuccess := true.
		result
	] ensure: [
		| current |
		current := transactionStack removeLast.
		isSuccess
			ifTrue: [
				current isNotEmpty ifTrue: [
					transactionStack isNotEmpty
						ifTrue: [ transactionStack last add: current ]
						ifFalse: [ self pushToUndo: current ] ] ]
			ifFalse: [
				isExecutingUndoRedo := true.
				[ current undo ] ensure: [ isExecutingUndoRedo := false ] ] ]
]

{ #category : 'initialization' }
OPUndoManager >> initialize [
	super initialize.
	undoStack := OrderedCollection new.
	redoStack := OrderedCollection new.
	transactionStack := OrderedCollection new.
	maxUndoSteps := self class defaultMaxUndoSteps.
	isExecutingUndoRedo := false.
	announcer := Announcer new
]

{ #category : 'accessing' }
OPUndoManager >> isExecutingUndoRedo [
	^ isExecutingUndoRedo
]

{ #category : 'testing' }
OPUndoManager >> isInTransaction [
	^ transactionStack isNotEmpty
]

{ #category : 'accessing' }
OPUndoManager >> maxUndoSteps [
	^ maxUndoSteps
]

{ #category : 'accessing' }
OPUndoManager >> maxUndoSteps: anInteger [
	"Set the maximum number of undo steps and trim existing history if needed."
	maxUndoSteps := anInteger.
	self enforceMaxUndoSteps.
	self announceChanged
]

{ #category : 'as yet unclassified' }
OPUndoManager >> pushToUndo: aCommand [
	undoStack addLast: aCommand.
	redoStack removeAll.
	self enforceMaxUndoSteps.
	self announceChanged
]

{ #category : 'actions api' }
OPUndoManager >> record: aCommand [
	"Record an executed command into the active transaction or directly into undo history."
	self isExecutingUndoRedo ifTrue: [ ^ self ].
	self isInTransaction
		ifTrue: [ self recordInTransaction: aCommand ]
		ifFalse: [ self recordDirectly: aCommand ]
]

{ #category : 'as yet unclassified' }
OPUndoManager >> recordDirectly: aCommand [
	redoStack removeAll.
	(undoStack isNotEmpty and: [ undoStack last canCoalesceWith: aCommand ])
		ifTrue: [
			undoStack last coalesceWith: aCommand.
			self announceChanged ]
		ifFalse: [
			self pushToUndo: aCommand ]
]

{ #category : 'as yet unclassified' }
OPUndoManager >> recordInTransaction: aCommand [
	| currentTransaction |
	currentTransaction := transactionStack last.
	(currentTransaction isNotEmpty and: [
		currentTransaction commands last canCoalesceWith: aCommand ])
			ifTrue: [ currentTransaction commands last coalesceWith: aCommand ]
			ifFalse: [ currentTransaction add: aCommand ]
]

{ #category : 'executing' }
OPUndoManager >> redo [
	"Execute redo of the last undone command with exception isolation."
	| command |
	self canRedo ifFalse: [ ^ self ].
	command := redoStack removeLast.
	isExecutingUndoRedo := true.
	[
		[
			command redo.
			undoStack addLast: command.
			self enforceMaxUndoSteps
		] on: Exception do: [ :ex |
			undoStack removeAll.
			ex pass ]
	] ensure: [
		isExecutingUndoRedo := false.
		self announceChanged ]
]

{ #category : 'accessing' }
OPUndoManager >> redoStack [
	^ redoStack
]

{ #category : 'accessing' }
OPUndoManager >> transactionStack [
	^ transactionStack
]

{ #category : 'undo/redo' }
OPUndoManager >> undo [
	"Execute undo of the last recorded command with exception isolation."
	| command |
	self canUndo ifFalse: [ ^ self ].
	command := undoStack removeLast.
	isExecutingUndoRedo := true.
	[
		[
			command undo.
			redoStack addLast: command
		] on: Exception do: [ :ex |
			redoStack removeAll.
			ex pass ]
	] ensure: [
		isExecutingUndoRedo := false.
		self announceChanged ]
]

{ #category : 'accessing' }
OPUndoManager >> undoStack [
	^ undoStack
]
