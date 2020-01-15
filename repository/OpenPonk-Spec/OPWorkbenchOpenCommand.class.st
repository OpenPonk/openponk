Class {
	#name : #OPWorkbenchOpenCommand,
	#superclass : #OPWorkbenchCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #accessing }
OPWorkbenchOpenCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectOpenMenuGroup order: 10 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPWorkbenchOpenCommand >> defaultMenuIcon [
	^ self iconNamed: #smallOpen
]

{ #category : #accessing }
OPWorkbenchOpenCommand >> defaultMenuItemName [
	^ 'Open Project...'
]

{ #category : #accessing }
OPWorkbenchOpenCommand >> execute [
	projectController openProject
]
