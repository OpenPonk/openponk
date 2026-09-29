"
Workbench toolbar command that prompts the user for a new file destination and saves the current project state to that location.
"
Class {
	#name : 'OPProjectSaveAsCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectSaveAsCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 15 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectSaveAsCommand >> defaultMenuIconName [

	^ #smallSaveAs
]

{ #category : 'accessing' }
OPProjectSaveAsCommand >> defaultMenuItemName [
	^ 'Save Project as...'
]

{ #category : 'execution' }
OPProjectSaveAsCommand >> execute [
	projectController saveProjectAs
]
