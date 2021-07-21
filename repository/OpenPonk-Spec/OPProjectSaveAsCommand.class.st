Class {
	#name : #OPProjectSaveAsCommand,
	#superclass : #OPProjectCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #accessing }
OPProjectSaveAsCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 15 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectSaveAsCommand >> defaultMenuIcon [
	^ self iconNamed: #smallSaveAs
]

{ #category : #accessing }
OPProjectSaveAsCommand >> defaultMenuItemName [
	^ 'Save Project as...'
]

{ #category : #accessing }
OPProjectSaveAsCommand >> execute [
	projectController saveProjectAs
]
