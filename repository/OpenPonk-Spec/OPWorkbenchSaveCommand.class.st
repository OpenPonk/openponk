Class {
	#name : #OPWorkbenchSaveCommand,
	#superclass : #OPWorkbenchCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #activation }
OPWorkbenchSaveCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 10 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPWorkbenchSaveCommand >> defaultMenuIcon [
	^ self iconNamed: #smallSave
]

{ #category : #accessing }
OPWorkbenchSaveCommand >> defaultMenuItemName [
	^ 'Save Project'
]

{ #category : #accessing }
OPWorkbenchSaveCommand >> execute [
	projectController saveProject
]
