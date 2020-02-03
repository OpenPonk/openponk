"
I provide default behavior for DCNavigator.

!! Collaborators

DCNavigator 
"
Class {
	#name : #OPDefaultNavigatorAdapter,
	#superclass : #OPNavigatorAdapter,
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #registering }
OPDefaultNavigatorAdapter class >> registerAdapter: aNavigator [
	"Do nothing. This adapter is attached explicitly from DCNavigator"

	
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> childrenMapping [
	^ {(Object -> #()).
	(OPProject -> #models)}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> contextMenuMapping [
	^ {Object -> {'Inspect' -> [ :obj | obj inspect ]}}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> displayMapping [
	^ {Object -> #className.
	OPProject -> 'Project'}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> iconMapping [
	^ {(OPProject -> OPIcons current openponkIcon).
	(Object ->
		(self iconNamed: #blank))}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> typesByDependency [
	^ #()
]
