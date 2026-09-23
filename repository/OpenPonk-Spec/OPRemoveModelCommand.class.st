Class {
	#name : 'OPRemoveModelCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'testing' }
OPRemoveModelCommand >> canBeExecuted [
	self selectedViewModel ifNil: [ ^ false ].
	^ (self selectedViewModel isKindOf: OPProjectViewModel) not
]

{ #category : 'executing' }
OPRemoveModelCommand >> execute [

	| viewModel controller model |
	viewModel := self selectedViewModel.
	model := viewModel model.
	controller := self projectController.
	SpConfirmDialog new
		title: 'Delete model?';
		message: 'Do you want to delete ' , model name asString , '?';
		acceptLabel: 'Yes, delete it';
		cancelLabel: 'Cancel';
		onAccept: [
				| command undoManager |
				undoManager := controller ifNotNil: [ :theController | theController undoManager ].
				command := OPRemoveModelElementCommand model: model projectController: controller.
				undoManager ifNotNil: [ :manager | manager inTransaction: [ manager execute: command ] ] ifNil: [ command execute ] ];
		openDialog
]

{ #category : 'accessing' }
OPRemoveModelCommand >> iconName [
	"Answer the icon name for the remove action in the project tree context menu."
	^ #glamorousTrash
]

{ #category : 'initialization' }
OPRemoveModelCommand >> initialize [
	super initialize.
	self name: 'Remove'
]
