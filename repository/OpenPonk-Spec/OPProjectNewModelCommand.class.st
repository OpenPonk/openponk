Class {
	#name : #OPProjectNewModelCommand,
	#superclass : #OPProjectCommand,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #activation }
OPProjectNewModelCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation byItemOf: OPWProjectOpenMenuGroup order: 20 for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectNewModelCommand >> defaultMenuIcon [
	^ self iconNamed: #glamorousAdd
]

{ #category : #accessing }
OPProjectNewModelCommand >> defaultMenuItemName [
	^ 'New model...'
]

{ #category : #execution }
OPProjectNewModelCommand >> execute [
	projectController inspect
]
