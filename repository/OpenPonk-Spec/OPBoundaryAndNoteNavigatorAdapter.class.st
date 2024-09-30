Class {
	#name : 'OPBoundaryAndNoteNavigatorAdapter',
	#superclass : 'OPNavigatorAdapter',
	#category : 'OpenPonk-Spec-Utils',
	#package : 'OpenPonk-Spec',
	#tag : 'Utils'
}

{ #category : 'accessing' }
OPBoundaryAndNoteNavigatorAdapter class >> priority [

	^ 50
]

{ #category : 'registering' }
OPBoundaryAndNoteNavigatorAdapter class >> registerAdapter: aNavigator [
	"Do nothing. This adapter is attached explicitly from DCNavigator"

	
]

{ #category : 'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> childrenMapping [
	^ {(OPBoundary -> #()).
	(OPNote -> #())}
]

{ #category : 'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> displayMapping [
	^ {(OPBoundary -> 'Boundary').
	(OPNote -> 'Note')}
]

{ #category : 'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> hasMappingFor: anObject in: aModel [

	^ (anObject isKindOf: OPBoundary) or: [ anObject isKindOf: OPNote ]
]

{ #category : 'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> iconMapping [
	^ {(OPBoundary -> (self iconNamed: #checkBoxOff)).
	(OPNote -> (self iconNamed: #announcement))}
]

{ #category : 'widget API' }
OPBoundaryAndNoteNavigatorAdapter >> typesByDependency [
	^ {OPNote. OPBoundary}
]
