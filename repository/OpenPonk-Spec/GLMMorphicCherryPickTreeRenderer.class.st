"
From old iceberg.

I'm a glamour renderer to render trees who can cherry-pick.
"
Class {
	#name : #GLMMorphicCherryPickTreeRenderer,
	#superclass : #GLMMorphicFastTreeRenderer,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #callbacks }
GLMMorphicCherryPickTreeRenderer >> actOnPresentationRefreshRequest: anAnnouncement [
	tableMorph window ifNil: [ ^ self ].
	tableMorph window isActive ifFalse: [ ^ self ].
	(tableMorph window boundsInWorld containsRect: tableMorph boundsInWorld) ifFalse: [ ^ self ].
	tableModel resetDataCache.
	tableMorph refresh
]

{ #category : #initialization }
GLMMorphicCherryPickTreeRenderer >> createDataSourceFrom: aPresentation [
	^ GLMCherryPickTreeDataSource new
]

{ #category : #initialization }
GLMMorphicCherryPickTreeRenderer >> specificTableMorphInitializiation [
	super specificTableMorphInitializiation.
	tableModel glamourPresentation isAllSelected
		ifTrue: [ tableModel selectAll ]
]
