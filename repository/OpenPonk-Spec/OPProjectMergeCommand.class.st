"
Workbench toolbar command that prompts the user to select another OpenPonk project file and merges its models and diagrams into the currently active project.
"
Class {
	#name : 'OPProjectMergeCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'activation' }
OPProjectMergeCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectOpenMenuGroup order: 15 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectMergeCommand >> defaultMenuIconName [

	^ #merge
]

{ #category : 'accessing' }
OPProjectMergeCommand >> defaultMenuItemName [
	^ 'Merge with project...'
]

{ #category : 'execution' }
OPProjectMergeCommand >> execute [

	projectController mergeFromFile
]
