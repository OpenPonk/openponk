"
Workbench toolbar command that prompts the user to select and load an existing OpenPonk project from the filesystem.
"
Class {
	#name : 'OPProjectOpenCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectOpenCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectOpenMenuGroup order: 10 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectOpenCommand >> defaultMenuIconName [

	^ #smallOpen
]

{ #category : 'accessing' }
OPProjectOpenCommand >> defaultMenuItemName [
	^ 'Open Project...'
]

{ #category : 'execution' }
OPProjectOpenCommand >> execute [
	OPProjectController openFromFile
]
