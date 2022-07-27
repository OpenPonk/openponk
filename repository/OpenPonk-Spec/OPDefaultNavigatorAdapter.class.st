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

{ #category : #accessing }
OPDefaultNavigatorAdapter class >> priority [

	^ 100
]

{ #category : #registering }
OPDefaultNavigatorAdapter class >> registerAdapter: aNavigator [
	"Do nothing. This adapter is attached explicitly from DCNavigator"

	
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> childrenMapping [
	^ {(Object -> #()).
	(OPProject -> #models).
	(OPTestContainerModel -> #entities)}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> displayMapping [
	^ {Object -> #className.
	OPProject -> 'Project'}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> hasMappingFor: anObject in: aModel [

	^ { 
		  OPProject.
		  OPTestModel.
		  OPTestContainerModel } anySatisfy: [ :any | 
		  anObject isKindOf: any ]
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> iconMapping [
	^ {(OPProject -> OPCoreIcons openponkIcon).
	(Object ->
		(self iconNamed: #blank))}
]

{ #category : #'widget API' }
OPDefaultNavigatorAdapter >> typesByDependency [
	^ #()
]
