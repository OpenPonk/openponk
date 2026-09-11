Class {
	#name : 'OPPanedLayoutPatchTest',
	#superclass : 'TestCase',
	#instVars : [
		'window'
	],
	#category : 'OpenPonk-Morphic-Tests',
	#package : 'OpenPonk-Morphic',
	#tag : 'Tests'
}

{ #category : 'running' }
OPPanedLayoutPatchTest >> tearDown [
	window ifNotNil: [ 
		window close.
		window := nil ].
	super tearDown
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
