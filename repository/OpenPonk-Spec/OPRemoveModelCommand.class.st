Class {
	#name : 'OPRemoveModelCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'as yet unclassified' }
OPRemoveModelCommand >> canBeExecuted [
	self selectedViewModel ifNil: [ ^ false ].
	^ (self selectedViewModel isKindOf: OPProjectViewModel) not
]

{ #category : 'as yet unclassified' }
OPRemoveModelCommand >> execute [
	| vm ctrl model |
	vm := self selectedViewModel.
	model := vm model.
	ctrl := self projectController.
	SpConfirmDialog new
		title: 'Delete model?';
		label: 'Do you want to delete ', model name asString , '?';
		acceptLabel: 'Yes, delete it';
		cancelLabel: 'Cancel';
		onAccept: [
			(ctrl hasModel: model)
				ifTrue: [ ctrl removeModel: model ]
				ifFalse: [ vm removeModel ] ];
		openDialog
]

{ #category : 'as yet unclassified' }
OPRemoveModelCommand >> initialize [
	super initialize.
	self name: 'Remove'
]
