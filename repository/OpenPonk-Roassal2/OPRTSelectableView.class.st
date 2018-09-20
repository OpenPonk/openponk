"
I am an interaction to select domain elements in a view.
"
Class {
	#name : #OPRTSelectableView,
	#superclass : #RTSelectableView,
	#instVars : [
		'candidatesBlock'
	],
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #util }
OPRTSelectableView >> candidates [
	^ candidatesBlock value
]

{ #category : #util }
OPRTSelectableView >> candidatesBlock: aBlock [
	candidatesBlock := aBlock
]

{ #category : #util }
OPRTSelectableView >> color [
	^ Color black alpha: 0.2
]

{ #category : #util }
OPRTSelectableView >> getSelectedElementsWith: aSelectionElement [
	| selected bounds candidates |
	selected := RTGroup new.
	bounds := aSelectionElement encompassingRectangle.
	candidates := self candidates copyWithout: aSelectionElement.
	selected := candidates select: [ :each | bounds intersects: each encompassingRectangle ].
	^ selected asGroup
]

{ #category : #initialization }
OPRTSelectableView >> initialize [
	super initialize.
	self when: RTSelectionChange do: [ :e | view attributeAt: self class put: e group ].
	self when: RTSelectionEnd do: [ :e | view attributeAt: self class put: e group ]
]

{ #category : #initialization }
OPRTSelectableView >> initializeElement: aView [
	super initializeElement: aView.
	view canvas eventOverseer ifNil: [ view canvas eventOverseer: TRAnnouncingOverseer new ].
	view canvas eventOverseer
		when: TRMouseLeftClick
		do: [ :evt | 
			self removeSelection: self candidates.
			view attributeAt: self class put: #() ]
]
