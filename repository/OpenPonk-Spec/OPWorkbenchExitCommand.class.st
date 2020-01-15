"
I close the opened workbench.
"
Class {
	#name : #OPWorkbenchExitCommand,
	#superclass : #OPWorkbenchCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #activation }
OPWorkbenchExitCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation
		byItemOf: OPWProjectExitMenuGroup
		order: 10
		for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPWorkbenchExitCommand >> defaultMenuIcon [
	^ self iconNamed: #smallQuit
]

{ #category : #accessing }
OPWorkbenchExitCommand >> defaultMenuItemName [
	^ 'Close Project'
]

{ #category : #accessing }
OPWorkbenchExitCommand >> execute [
	workbench delete
]
