Class {
	#name : #OPProjectOpenCommand,
	#superclass : #OPProjectCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #accessing }
OPProjectOpenCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectOpenMenuGroup order: 10 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectOpenCommand >> defaultMenuIcon [
	^ self iconNamed: #smallOpen
]

{ #category : #accessing }
OPProjectOpenCommand >> defaultMenuItemName [
	^ 'Open Project...'
]

{ #category : #accessing }
OPProjectOpenCommand >> execute [
	OPProjectController openFromFile
]
