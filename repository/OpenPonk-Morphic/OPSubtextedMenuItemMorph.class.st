Class {
	#name : #OPSubtextedMenuItemMorph,
	#superclass : #ToggleMenuItemMorph,
	#instVars : [
		'subtext'
	],
	#category : #'OpenPonk-Morphic-Polymorph'
}

{ #category : #'as yet unclassified' }
OPSubtextedMenuItemMorph >> boundsForSubtext: aString font: aFont [

	| ownerRight ktp ktw b scrollbarredOwner |
	scrollbarredOwner := self ownerThatIsA: GeneralScrollPaneMorph.
	ownerRight := self owner right
	              - (scrollbarredOwner vScrollbarShowing
			               ifTrue: [ scrollbarredOwner vScrollbar width ]
			               ifFalse: [ 0 ]).
	ktp := self hasSubMenu
		       ifTrue: [ ownerRight - self subMenuMarker width ]
		       ifFalse: [ ownerRight ].
	ktp := ktp - (ktw := aFont widthOfString: aString).
	b := ktp @ (self bounds top + self bounds bottom - aFont height // 2) 
		     extent: ktw @ self height.
	^ b
]

{ #category : #drawing }
OPSubtextedMenuItemMorph >> drawOn: aCanvas [

	"Need to check isEnabled here."

	self
		isEnabled;
		drawSubtextOn: aCanvas;
		basicDrawOn: aCanvas
]

{ #category : #'as yet unclassified' }
OPSubtextedMenuItemMorph >> drawSubtextOn: aCanvas [

	"Draw the key text on the canvas."

	| subtextBounds |
	subtext ifNil: [ ^ self ].
	subtextBounds := self boundsForSubtext: subtext font: self fontToUse.
	self
		drawText: subtext
		on: aCanvas
		in: subtextBounds
		color: self theme darkBaseColor
]

{ #category : #accessing }
OPSubtextedMenuItemMorph >> subtext [

	^ subtext
]

{ #category : #accessing }
OPSubtextedMenuItemMorph >> subtext: aString [

	subtext := aString
]
