Class {
	#name : #OPProjectSaveCommand,
	#superclass : #OPProjectCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #activation }
OPProjectSaveCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 10 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectSaveCommand >> defaultMenuIcon [
	^ self iconNamed: #smallSave
]

{ #category : #accessing }
OPProjectSaveCommand >> defaultMenuItemName [
	^ 'Save Project'
]

{ #category : #accessing }
OPProjectSaveCommand >> execute [
	projectController saveProject
]
