Class {
	#name : 'OPProjectMergeCommand',
	#superclass : 'OPProjectCommand',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPProjectMergeCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectOpenMenuGroup order: 15 for: OPWorkbenchToolbar
]

{ #category : 'accessing' }
OPProjectMergeCommand >> defaultMenuIcon [

	^ self iconNamed: #merge
]

{ #category : 'accessing' }
OPProjectMergeCommand >> defaultMenuItemName [
	^ 'Merge with project...'
]

{ #category : 'execution' }
OPProjectMergeCommand >> execute [

	projectController mergeFromFile
]
