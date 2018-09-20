"
I override my parent so a user can specify the width of the action list.
"
Class {
	#name : #OPGLMActionListPresentation,
	#superclass : #GLMActionListPresentation,
	#instVars : [
		'width'
	],
	#category : 'OpenPonk-UI-Glamour'
}

{ #category : #rendering }
OPGLMActionListPresentation >> renderGlamorouslyOn: aRenderer [
	self registerAnnouncements.
	^ aRenderer renderOPActionListPresentation: self
]

{ #category : #accessing }
OPGLMActionListPresentation >> width [
	^ width
]

{ #category : #accessing }
OPGLMActionListPresentation >> width: aSize [
	width := aSize
]
