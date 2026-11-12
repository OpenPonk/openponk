"
Verifies that commands correctly declare whether their execution alters domain model semantics for undo tracking.
"
Class {
	#name : 'OPCommandAffectsModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-UndoRedo',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'UndoRedo'
}

{ #category : 'tests' }
OPCommandAffectsModelTest >> testCommandAffectsModelByDefault [
	self
		assert: OPUndoTestLoggingCommand new affectsModel
		description: 'Commands should report affectsModel = true by default'
]

{ #category : 'tests' }
OPCommandAffectsModelTest >> testCompositeCommandAffectsModelOnlyIfAnySubcommandDoes [
	| compositeCommand |
	compositeCommand := OPCompositeCommand new.
	self
		deny: compositeCommand affectsModel
		description: 'Empty composite command must not affect model'.

	compositeCommand add: OPChangeBoundsCommand new.
	self
		deny: compositeCommand affectsModel
		description: 'Composite command with only diagram geometry commands must not affect model'.

	compositeCommand add: OPUndoTestLoggingCommand new.
	self
		assert: compositeCommand affectsModel
		description: 'Composite command containing a model command must report affectsModel = true'
]

{ #category : 'tests' }
OPCommandAffectsModelTest >> testDiagramCommandsDoNotAffectModel [
	self
		deny: OPChangeBoundsCommand new affectsModel
		description: 'OPChangeBoundsCommand must not affect domain model'.
	self
		deny: OPChangeAnchoredBoundsCommand new affectsModel
		description: 'OPChangeAnchoredBoundsCommand must not affect domain model'.
	self
		deny: OPModifyEdgeWaypointsCommand new affectsModel
		description: 'OPModifyEdgeWaypointsCommand must not affect domain model'.
	self
		deny: OPChangeDiagramElementStylePropertyCommand new affectsModel
		description: 'OPChangeDiagramElementStylePropertyCommand must not affect domain model'.
	self
		deny: OPHideDiagramElementCommand new affectsModel
		description: 'OPHideDiagramElementCommand must not affect domain model'.
	self
		deny: OPShowDiagramElementCommand new affectsModel
		description: 'OPShowDiagramElementCommand must not affect domain model'.
	self
		deny: OPRenameDiagramCommand new affectsModel
		description: 'OPRenameDiagramCommand must not affect domain model'
]

{ #category : 'tests' }
OPCommandAffectsModelTest >> testUndoManagerNotifiesCommandOnRecordAndUndo [
	| undoManager capturedCommands loggingCommand |
	undoManager := OPUndoManager new.
	capturedCommands := OrderedCollection new.
	undoManager announcer
		when: OPUndoRedoChanged
		do: [ :anAnnouncement | capturedCommands add: anAnnouncement command ]
		for: self.

	loggingCommand := OPUndoTestLoggingCommand new
		log: OrderedCollection new;
		value: 'test';
		yourself.
	undoManager execute: loggingCommand.
	self assert: capturedCommands last identicalTo: loggingCommand.

	undoManager undo.
	self assert: capturedCommands last identicalTo: loggingCommand.

	undoManager redo.
	self assert: capturedCommands last identicalTo: loggingCommand
]

{ #category : 'tests' }
OPCommandAffectsModelTest >> testUndoRedoChangedCarriesCommand [
	| command announcement |
	command := OPUndoTestLoggingCommand new.
	announcement := OPUndoRedoChanged command: command.
	self assert: announcement command identicalTo: command
]
