Class {
	#name : #OPRSOrthogonalBorderAttachPoint,
	#superclass : #RSBorderAttachPoint,
	#category : #'OpenPonk-Roassal3-AttachPoints'
}

{ #category : #'public - hooks' }
OPRSOrthogonalBorderAttachPoint >> borderPointFrom: aSource to: aTarget via: aLine [

	| sourceLeft sourceRight sourceTop sourceBottom targetLeft targetRight targetTop targetBottom |
	sourceLeft := aSource left.
	sourceRight := aSource right.
	sourceTop := aSource top.
	sourceBottom := aSource bottom.
	targetLeft := aTarget left.
	targetRight := aTarget right.
	targetTop := aTarget top.
	targetBottom := aTarget bottom.

	(sourceLeft between: targetLeft + 2 and: targetRight - 2) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget ].
	(sourceRight between: targetLeft + 2 and: targetRight - 2) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget ].
	(targetLeft between: sourceLeft + 2 and: sourceRight - 2) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget ].
	(targetRight between: sourceLeft + 2 and: sourceRight - 2) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget ].

	(sourceTop between: targetTop + 2 and: targetBottom - 2) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget ].
	(sourceBottom between: targetTop + 2 and: targetBottom - 2) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget ].
	(targetTop between: sourceTop + 2 and: sourceBottom - 2) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget ].
	(targetBottom between: sourceTop + 2 and: sourceBottom - 2) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget ].

	^ super borderPointFrom: aSource to: aTarget via: aLine
]

{ #category : #'public - hooks' }
OPRSOrthogonalBorderAttachPoint >> orthogonalCoordinateFromMin: srcMin max: srcMax toMin: tgtMin max: tgtMax [

	| srcWidth tgtWidth srcCenter tgtCenter centersDiff ratio |
	srcWidth := srcMax - srcMin.
	tgtWidth := tgtMax - tgtMin.

	srcCenter := srcMax + srcMin / 2.
	tgtCenter := tgtMax + tgtMin / 2.

	centersDiff := tgtCenter - srcCenter.

	ratio := srcWidth / (srcWidth + tgtWidth).
	^ centersDiff * ratio + srcCenter
]

{ #category : #'public - hooks' }
OPRSOrthogonalBorderAttachPoint >> orthogonalXBorderPointFrom: aSource to: aTarget [

	| x y |
	y := aSource center y > aTarget center y
		     ifTrue: [ aSource top ]
		     ifFalse: [ aSource bottom ].

	x := self
		     orthogonalCoordinateFromMin: aSource left
		     max: aSource right
		     toMin: aTarget left
		     max: aTarget right.

	^ x @ y
]

{ #category : #'public - hooks' }
OPRSOrthogonalBorderAttachPoint >> orthogonalYBorderPointFrom: aSource to: aTarget [

	| x y |
	x := aSource center x > aTarget center x
		     ifTrue: [ aSource left ]
		     ifFalse: [ aSource right ].

	y := self
		     orthogonalCoordinateFromMin: aSource top
		     max: aSource bottom
		     toMin: aTarget top
		     max: aTarget bottom.

	^ x @ y
]
