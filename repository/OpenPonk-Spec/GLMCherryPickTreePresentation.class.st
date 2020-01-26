"
From old iceberg.

I'm a glamour presentation to define trees who can cherry-pick.
"
Class {
	#name : #GLMCherryPickTreePresentation,
	#superclass : #GLMFastTreePresentation,
	#instVars : [
		'allSelected'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #accessing }
GLMCherryPickTreePresentation >> allSelected [
	allSelected := true
]

{ #category : #accessing }
GLMCherryPickTreePresentation >> cherryPick [
	^ (self pane port: #cherryPick) value
]

{ #category : #accessing }
GLMCherryPickTreePresentation >> cherryPick: aValuable [
	^ (self pane port: #cherryPick) value: aValuable
]

{ #category : #initialization }
GLMCherryPickTreePresentation >> initialize [
	super initialize.
	allSelected := false
]

{ #category : #testing }
GLMCherryPickTreePresentation >> isAllSelected [
	^ allSelected
]

{ #category : #accessing }
GLMCherryPickTreePresentation >> onChangeOfCherryPick: aBlock [
	self onChangeOfPort: #cherryPick act: aBlock
]

{ #category : #rendering }
GLMCherryPickTreePresentation >> renderGlamorouslyOn: aRenderer [ 
	self registerAnnouncements.
	^ aRenderer renderOPCherryPickTreePresentation: self
]
