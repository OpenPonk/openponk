Class {
	#name : #OPWorkbenchSaveAsCommand,
	#superclass : #OPWorkbenchCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #accessing }
OPWorkbenchSaveAsCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectSaveMenuGroup order: 15 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPWorkbenchSaveAsCommand >> defaultMenuIcon [
	^ self iconNamed: #smallSaveAs
]

{ #category : #accessing }
OPWorkbenchSaveAsCommand >> defaultMenuItemName [
	^ 'Save Project as...'
]

{ #category : #accessing }
OPWorkbenchSaveAsCommand >> execute [
	projectController saveProjectAs
]
