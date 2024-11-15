"
I close the opened workbench.
"
Class {
	#name : 'OPProjectExitCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
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

{ #category : 'accessing' }
OPProjectExitCommand >> execute [

	workbench close
]
