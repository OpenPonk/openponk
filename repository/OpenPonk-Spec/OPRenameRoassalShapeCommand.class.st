Class {
	#name : 'OPRenameRoassalShapeCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'activation' }
OPRenameRoassalShapeCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: KeyboardKey F2 asKeyCombination for: OPCanvasPresenter
]

{ #category : 'activation' }
OPRenameRoassalShapeCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemOrder: 20 for: OPCanvasPresenter
]

{ #category : 'testing' }
OPRenameRoassalShapeCommand >> canBeExecuted [
	^ controllers isNotNil and: [ controllers size = 1 ]
]

{ #category : 'accessing' }
OPRenameRoassalShapeCommand >> defaultMenuIconName [
	^ #glamorousEdit
]

{ #category : 'accessing' }
OPRenameRoassalShapeCommand >> defaultMenuItemName [
	^ 'Rename'
]

{ #category : 'execution' }
OPRenameRoassalShapeCommand >> execute [
	self canBeExecuted ifFalse: [ ^ self ].
	diagramController selectController: controllers anyOne.
	diagramController form ifNotNil: #focusFirstInput
]
