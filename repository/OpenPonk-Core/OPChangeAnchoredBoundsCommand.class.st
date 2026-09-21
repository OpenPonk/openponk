"
I represent an undoable command that modifies the geometric bounds of an anchored diagram element (e.g. labels, notes).
"
Class {
	#name : 'OPChangeAnchoredBoundsCommand',
	#superclass : 'OPChangeBoundsCommand',
	#instVars : [
		'oldBalance',
		'newBalance',
		'oldDistanceToLine',
		'newDistanceToLine'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'executing' }
OPChangeAnchoredBoundsCommand >> execute [
	super execute.
	self restoreAnchorWithBalance: newBalance distance: newDistanceToLine
]

{ #category : 'accessing' }
OPChangeAnchoredBoundsCommand >> newBalance [
	^ newBalance
]

{ #category : 'accessing' }
OPChangeAnchoredBoundsCommand >> newDistanceToLine [
	^ newDistanceToLine
]

{ #category : 'accessing' }
OPChangeAnchoredBoundsCommand >> oldBalance [
	^ oldBalance
]

{ #category : 'accessing' }
OPChangeAnchoredBoundsCommand >> oldBalance: aNumber newBalance: anotherNumber oldDistanceToLine: aDist newDistanceToLine: anotherDist [
	oldBalance := aNumber.
	newBalance := anotherNumber.
	oldDistanceToLine := aDist.
	newDistanceToLine := anotherDist
]

{ #category : 'accessing' }
OPChangeAnchoredBoundsCommand >> oldDistanceToLine [
	^ oldDistanceToLine
]

{ #category : 'executing' }
OPChangeAnchoredBoundsCommand >> restoreAnchorWithBalance: aBalance distance: aDistance [
	element roassalShape ifNotNil: [ :roassalShape |
		(roassalShape propertyAt: OPRSAnchorConstraint ifAbsent: [ nil ]) ifNotNil: [ :anchorConstraint |
			aBalance ifNotNil: [ anchorConstraint balance: aBalance ].
			aDistance ifNotNil: [ anchorConstraint distanceToLine: aDistance ].
			anchorConstraint moveShape ] ]
]

{ #category : 'executing' }
OPChangeAnchoredBoundsCommand >> undo [
	super undo.
	self restoreAnchorWithBalance: oldBalance distance: oldDistanceToLine
]
