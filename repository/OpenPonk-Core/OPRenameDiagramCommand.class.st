"
I represent an undoable command that changes the name of an OpenPonk diagram.
"
Class {
	#name : 'OPRenameDiagramCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'diagram',
		'newName',
		'oldName',
		'project'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPRenameDiagramCommand class >> diagram: aDiagram newName: aString [
	^ self new
		diagram: aDiagram;
		newName: aString;
		yourself
]

{ #category : 'instance creation' }
OPRenameDiagramCommand class >> diagram: aDiagram newName: aString project: aProject [
	^ self new
		diagram: aDiagram newName: aString project: aProject;
		yourself
]

{ #category : 'announcing' }
OPRenameDiagramCommand >> announceRenameFrom: fromName to: toName [
	project ifNotNil: [ :p |
		p announcer announce: (OPDiagramRenamed diagram: diagram oldName: fromName newName: toName) ]
]

{ #category : 'accessing' }
OPRenameDiagramCommand >> diagram: aDiagram [
	diagram := aDiagram.
	oldName := aDiagram name
]

{ #category : 'initialization' }
OPRenameDiagramCommand >> diagram: aDiagram newName: aString project: aProject [
	diagram := aDiagram.
	newName := aString.
	project := aProject
]

{ #category : 'executing' }
OPRenameDiagramCommand >> execute [
	oldName ifNil: [ oldName := diagram name ].
	diagram name: newName.
	self announceRenameFrom: oldName to: newName
]

{ #category : 'accessing' }
OPRenameDiagramCommand >> newName: aString [
	newName := aString
]

{ #category : 'executing' }
OPRenameDiagramCommand >> redo [
	self execute
]

{ #category : 'executing' }
OPRenameDiagramCommand >> undo [
	diagram name: oldName.
	self announceRenameFrom: newName to: oldName
]
