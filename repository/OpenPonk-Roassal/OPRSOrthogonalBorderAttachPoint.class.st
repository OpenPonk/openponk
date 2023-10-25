Class {
	#name : #OPRSOrthogonalBorderAttachPoint,
	#superclass : #RSBorderAttachPoint,
	#category : #'OpenPonk-Roassal-AttachPoints'
}

{ #category : #'public - hooks' }
OPRSOrthogonalBorderAttachPoint >> borderPointFrom: aSource to: aTarget via: aLine [

	| sourceLeft sourceRight sourceTop sourceBottom targetLeft targetRight targetTop targetBottom shift orthogonalityAllowance |
	sourceLeft := aSource left.
	sourceRight := aSource right.
	sourceTop := aSource top.
	sourceBottom := aSource bottom.
	targetLeft := aTarget left.
	targetRight := aTarget right.
	targetTop := aTarget top.
	targetBottom := aTarget bottom.

	shift := aLine a * aSource center x + (aLine b * aSource center y)
	         + aLine c / (aLine a squared + aLine b squared) sqrt.

	orthogonalityAllowance := 1 + (2 * shift abs).

	(sourceLeft + orthogonalityAllowance
		 between: targetLeft
		 and: targetRight) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget shift: shift ].
	(sourceRight - orthogonalityAllowance
		 between: targetLeft
		 and: targetRight) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget shift: shift ].
	(targetLeft + orthogonalityAllowance
		 between: sourceLeft
		 and: sourceRight) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget shift: shift ].
	(targetRight - orthogonalityAllowance
		 between: sourceLeft
		 and: sourceRight) ifTrue: [
		^ self orthogonalXBorderPointFrom: aSource to: aTarget shift: shift ].

	(sourceTop + orthogonalityAllowance
		 between: targetTop
		 and: targetBottom) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget shift: shift ].
	(sourceBottom - orthogonalityAllowance
		 between: targetTop
		 and: targetBottom) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget shift: shift ].
	(targetTop + orthogonalityAllowance
		 between: sourceTop
		 and: sourceBottom) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget shift: shift ].
	(targetBottom - orthogonalityAllowance
		 between: sourceTop
		 and: sourceBottom) ifTrue: [
		^ self orthogonalYBorderPointFrom: aSource to: aTarget shift: shift ].

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
OPRSOrthogonalBorderAttachPoint >> orthogonalXBorderPointFrom: aSource to: aTarget shift: aShift [

	| x y shift |
	y := aSource center y > aTarget center y
		     ifTrue: [ aSource top ]
		     ifFalse: [ aSource bottom ].

	x := self
		     orthogonalCoordinateFromMin: aSource left
		     max: aSource right
		     toMin: aTarget left
		     max: aTarget right.

	shift := aShift.
	aTarget center y < aSource center y ifTrue: [ shift := shift negated ].

	^ x + shift @ y
]

{ #category : #'public - hooks' }
OPRSOrthogonalBorderAttachPoint >> orthogonalYBorderPointFrom: aSource to: aTarget shift: aShift [

	| x y shift |
	x := aSource center x > aTarget center x
		     ifTrue: [ aSource left ]
		     ifFalse: [ aSource right ].

	y := self
		     orthogonalCoordinateFromMin: aSource top
		     max: aSource bottom
		     toMin: aTarget top
		     max: aTarget bottom.

	shift := aShift.
	aSource center x < aTarget center x ifTrue: [ shift := shift negated ].

	^ x @ (y + shift)
]
