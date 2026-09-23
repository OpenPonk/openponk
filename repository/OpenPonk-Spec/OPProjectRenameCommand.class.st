Class {
	#name : 'OPProjectRenameCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectRenameCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 20 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectRenameCommand >> defaultMenuIconName [
	^ #glamorousEdit
]

{ #category : 'accessing' }
OPProjectRenameCommand >> defaultMenuItemName [
	^ 'Rename Project...'
]

{ #category : 'execution' }
OPProjectRenameCommand >> execute [
	workbench renameProject
]
