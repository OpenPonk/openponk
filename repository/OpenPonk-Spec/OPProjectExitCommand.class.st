"
I close the opened workbench.
"
Class {
	#name : #OPProjectExitCommand,
	#superclass : #OPProjectCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #activation }
OPProjectExitCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation
		byItemOf: OPWProjectExitMenuGroup
		order: 10
		for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectExitCommand >> defaultMenuIcon [
	^ self iconNamed: #smallQuit
]

{ #category : #accessing }
OPProjectExitCommand >> defaultMenuItemName [
	^ 'Close Project'
]

{ #category : #accessing }
OPProjectExitCommand >> execute [
	workbench delete
]
