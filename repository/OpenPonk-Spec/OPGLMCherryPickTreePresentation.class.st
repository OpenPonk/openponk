Class {
	#name : #OPGLMCherryPickTreePresentation,
	#superclass : #GLMCherryPickTreePresentation,
	#instVars : [
		'initialPick',
		'selectionCascade'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #accessing }
OPGLMCherryPickTreePresentation >> initialPick [
	^ initialPick ifNil: [ Set new ]
]

{ #category : #accessing }
OPGLMCherryPickTreePresentation >> initialPick: aSet [
	initialPick := aSet
]

{ #category : #rendering }
OPGLMCherryPickTreePresentation >> renderGlamorouslyOn: aRenderer [ 
	self registerAnnouncements.
	^ aRenderer renderOPCherryPickTreePresentation: self
]

{ #category : #accessing }
OPGLMCherryPickTreePresentation >> selectionCascade [
	^ selectionCascade
]

{ #category : #accessing }
OPGLMCherryPickTreePresentation >> selectionCascade: aOneArgBlock [
	selectionCascade := aOneArgBlock
]
