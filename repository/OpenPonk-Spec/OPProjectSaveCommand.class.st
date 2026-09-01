"
Workbench toolbar command that saves the current project state to its existing file location, or prompts for a destination if it has not been saved yet.
"
Class {
	#name : 'OPProjectSaveCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectSaveCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 10 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectSaveCommand >> defaultMenuIconName [

	^ #smallSave
]

{ #category : 'accessing' }
OPProjectSaveCommand >> defaultMenuItemName [
	^ 'Save Project'
]

{ #category : 'execution' }
OPProjectSaveCommand >> execute [
	projectController saveProject
]
