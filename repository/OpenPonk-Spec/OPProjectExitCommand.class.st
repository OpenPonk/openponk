"
Workbench toolbar command that prompts the user (if unsaved) and closes the currently active OpenPonk workbench window and project.
"
Class {
	#name : 'OPProjectExitCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectExitCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation
		byItemOf: OPWProjectExitMenuGroup
		order: 10
		for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectExitCommand >> defaultMenuIconName [

	^ #smallQuit
]

{ #category : 'accessing' }
OPProjectExitCommand >> defaultMenuItemName [
	^ 'Close Project'
]

{ #category : 'execution' }
OPProjectExitCommand >> execute [

	workbench close
]
