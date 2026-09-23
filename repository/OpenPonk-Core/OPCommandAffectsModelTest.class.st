Class {
	#name : 'OPCommandAffectsModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'tests' }
OPCommandAffectsModelTest >> testCommandAffectsModelByDefault [
	self assert: OPUndoTestLoggingCommand new affectsModel
]

{ #category : 'tests' }
OPCommandAffectsModelTest >> testCompositeCommandAffectsModelOnlyIfAnySubcommandDoes [
	| compositeCommand |
	compositeCommand := OPCompositeCommand new.
	self deny: compositeCommand affectsModel.

	compositeCommand add: OPChangeBoundsCommand new.
	self deny: compositeCommand affectsModel.

	compositeCommand add: OPUndoTestLoggingCommand new.
	self assert: compositeCommand affectsModel
]

{ #category : 'tests' }
OPCommandAffectsModelTest >> testDiagramCommandsDoNotAffectModel [
	self deny: OPChangeBoundsCommand new affectsModel.
	self deny: OPChangeAnchoredBoundsCommand new affectsModel.
	self deny: OPModifyEdgeWaypointsCommand new affectsModel.
	self deny: OPChangeDiagramElementStylePropertyCommand new affectsModel.
	self deny: OPHideDiagramElementCommand new affectsModel.
	self deny: OPShowDiagramElementCommand new affectsModel.
	self deny: OPRenameDiagramCommand new affectsModel
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
