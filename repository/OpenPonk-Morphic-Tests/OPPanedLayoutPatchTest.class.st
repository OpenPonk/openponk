"
Verifies application and layout behavior of OPPanedLayoutPatch on SpMorphicPanedLayout and paned resizer morphs.
"
Class {
	#name : 'OPPanedLayoutPatchTest',
	#superclass : 'TestCase',
	#instVars : [
		'window'
	],
	#category : 'OpenPonk-Morphic-Tests-Morphic',
	#package : 'OpenPonk-Morphic-Tests',
	#tag : 'Morphic'
}

{ #category : 'running' }
OPPanedLayoutPatchTest >> tearDown [
	window ifNotNil: [ 
		window close.
		window := nil ].
	super tearDown
]

{ #category : 'tests' }
OPPanedLayoutPatchTest >> testApplyPatchAndPanedLayoutCalculations [
	| layout containerMorph firstPane resizerMorph lastPane horizontalResizer verticalResizer |
	OPPanedLayoutPatch applyLayoutPolicyChanges.
	OPPanedLayoutPatch applyResizerChanges.
	OPPanedLayoutPatch apply.
	layout := SpMorphicPanedLayout new.
	self
		deny: layout isFromEnd
		description: 'Default layout without position should not be from end'.
	self
		deny: layout isFixed
		description: 'Default layout without position should not be fixed'.
	self
		deny: layout isResizing
		description: 'Newly initialized layout should not be resizing'.
	self assert: (layout widthPositionIn: 200 @ 100) equals: 100.
	self assert: (layout heightPositionIn: 200 @ 100) equals: 50.
	layout position: -250.
	self
		assert: layout isFromEnd
		description: 'Negative position should mark layout as from end'.
	self
		assert: layout isFixed
		description: 'Position with absolute value >= 1 should mark layout as fixed'.
	self assert: (layout widthPositionIn: 800 @ 600) equals: 250.
	self assert: (layout heightPositionIn: 800 @ 600) equals: 250.
	layout resetPosition.
	self
		assert: layout isResizing
		description: 'resetPosition should mark layout as resizing'.
	layout position: 0.25.
	self
		deny: layout isFromEnd
		description: 'Positive fractional position should not be from end'.
	self
		deny: layout isFixed
		description: 'Fractional position < 1 should not be fixed'.
	self assert: (layout widthPositionIn: 400 @ 200) equals: 100.
	horizontalResizer := SpPanedResizerMorph newHorizontal.
	self
		deny: horizontalResizer isFromEnd
		description: 'Unattached horizontal resizer should not be from end'.
	verticalResizer := SpPanedResizerMorph newVertical.
	self
		deny: verticalResizer isFromEnd
		description: 'Unattached vertical resizer should not be from end'.
	containerMorph := Morph new
		extent: 400 @ 200;
		layoutPolicy: layout;
		yourself.
	firstPane := Morph new extent: 80 @ 200; yourself.
	resizerMorph := SpPanedResizerMorph newHorizontal extent: 5 @ 200; yourself.
	lastPane := Morph new extent: 315 @ 200; yourself.
	containerMorph
		addMorphBack: firstPane;
		addMorphBack: resizerMorph;
		addMorphBack: lastPane.
	layout ensureWidthPosition: containerMorph in: (0 @ 0 extent: 400 @ 200).
	self assert: firstPane width equals: 100.
	self assert: firstPane hResizing equals: #rigid.
	self assert: lastPane hResizing equals: #spaceFill.
	layout ensureHeightPosition: containerMorph in: (0 @ 0 extent: 400 @ 200).
	layout position: -120.
	layout ensureWidthPosition: containerMorph in: (0 @ 0 extent: 400 @ 200).
	self assert: lastPane width equals: 120
]

{ #category : 'tests' }
OPPanedLayoutPatchTest >> testTrailingPanelPreservesWidthOnWindowResize [
	| presenter leftPane rightPane targetWidth initialLeftWidth |
	targetWidth := 260.

	presenter := SpPresenter new.
	presenter application: SpApplication new.
	presenter layout: (SpPanedLayout newLeftToRight
		positionOfSlider: targetWidth negated;
		first: (leftPane := presenter newLabel label: 'Main');
		second: (rightPane := presenter newLabel label: 'Sidebar');
		yourself).

	window := presenter open.
	window adapter widget extent: 800 @ 600.
	window adapter widget fullBounds.

	initialLeftWidth := leftPane adapter widget width.

	self assert: rightPane adapter widget width equals: targetWidth.
	self assert: rightPane adapter widget hResizing equals: #rigid.
	self assert: leftPane adapter widget hResizing equals: #spaceFill.

	"Resize open window morph horizontally by 400 px"
	window adapter widget extent: 1200 @ 600.
	window adapter widget fullBounds.

	self assert: rightPane adapter widget width equals: targetWidth.
	self assert: leftPane adapter widget width equals: initialLeftWidth + 400
]
