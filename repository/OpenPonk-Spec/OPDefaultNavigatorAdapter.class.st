"
I provide default behavior for DCNavigator.

!! Collaborators

DCNavigator 
"
Class {
	#name : #OPDefaultNavigatorAdapter,
	#superclass : #OPNavigatorAdapter,
	#category : 'OpenPonk-Spec-Utils'
}

{ #category : #registering }
OPDefaultNavigatorAdapter class >> registerAdapter: aNavigator [
	"Do nothing. This adapter is attached explicitly from DCNavigator"

	
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> childrenMapping [
	^ {OPNamedElement -> [ #() ].
	OPDiagram -> #elements.
	Object -> [ #() ].
	OPProject -> #models}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> contextMenuMapping [
	^ {Object -> {'Inspect' -> [ :obj | obj inspect ]}}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> displayMapping [
	^ {OPModelObject -> #className.
	OPProject -> 'Project'}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> iconMapping [
	^ {OPDiagram -> OPIcons current dcFsmDiagramIcon.
	OPNamedElement -> OPIcons current dcFsmRegularStateIcon.
	OPEdge -> OPIcons current dcFsmTransitionIcon.
	OPProject -> OPIcons current openponkIcon.
	Object -> #blank asIcon}
]
