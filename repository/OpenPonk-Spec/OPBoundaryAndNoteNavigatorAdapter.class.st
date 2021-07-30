Class {
	#name : #OPBoundaryAndNoteNavigatorAdapter,
	#superclass : #OPNavigatorAdapter,
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #registering }
OPBoundaryAndNoteNavigatorAdapter class >> registerAdapter: aNavigator [
	"Do nothing. This adapter is attached explicitly from DCNavigator"

	
]

{ #category : #'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> childrenMapping [
	^ {(OPBoundary -> #()).
	(OPNote -> #())}
]

{ #category : #'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> displayMapping [
	^ {(OPBoundary -> 'Boundary').
	(OPNote -> 'Note')}
]

{ #category : #'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> hasMappingFor: anObject [
	^ {OPBoundary.
	OPNote} anySatisfy: [ :any | anObject isKindOf: any ]
]

{ #category : #'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> iconMapping [
	^ {(OPBoundary -> (self iconNamed: #checkBoxOff)).
	(OPNote -> (self iconNamed: #announcement))}
]

{ #category : #'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> typesByDependency [
	^ {OPNote. OPBoundary}
]
