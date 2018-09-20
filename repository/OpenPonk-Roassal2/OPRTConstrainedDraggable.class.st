Class {
	#name : #OPRTConstrainedDraggable,
	#superclass : #RTAbstractDraggable,
	#instVars : [
		'constraint'
	],
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #accessing }
OPRTConstrainedDraggable >> constraint: aOneArgBlock [
	constraint := aOneArgBlock
]

{ #category : #hooks }
OPRTConstrainedDraggable >> constraintIfNecessary: anElement [
	"Do nothing. Constraint is achieved via movement transformation."
]

{ #category : #initialization }
OPRTConstrainedDraggable >> initialize [
	super initialize.
	constraint := [ :anElement | false ]
]

{ #category : #hooks }
OPRTConstrainedDraggable >> transformDistance: distanceAsPoint forElement: anElement [
	^ constraint value: distanceAsPoint value: anElement
]
