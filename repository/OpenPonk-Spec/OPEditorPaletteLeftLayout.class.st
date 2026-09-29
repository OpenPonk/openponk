"
Concrete layout strategy for the OpenPonk editor that positions the creation palette on the left side of the diagram canvas.
"
Class {
	#name : 'OPEditorPaletteLeftLayout',
	#superclass : 'OPEditorLayout',
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'accessing' }
OPEditorPaletteLeftLayout >> name [

	^ 'Palette on left'
]

{ #category : 'applying' }
OPEditorPaletteLeftLayout >> resizePanelsOf: aMorph afterWindowResized: aResizeEvent [

	| canvaslayoutPolicy canvasWidth diff |
	aResizeEvent newSize x < 500 ifTrue: [ ^ self ].

	diff := aResizeEvent newSize x - aResizeEvent oldSize x.

	canvaslayoutPolicy := aMorph submorphs third layoutPolicy.

	canvasWidth := aMorph submorphs third submorphs first extent x.

	aMorph layoutPolicy position: aMorph submorphs first extent x.
	canvaslayoutPolicy position: canvasWidth + diff
]

{ #category : 'applying' }
OPEditorPaletteLeftLayout >> spLayoutFor: anEditor [
	"[ Palette | Canvas ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: OPPalette initialWidth;
		  add: self paletteSectionLayout withConstraints: [ :constraints |
				  constraints
					  beNotResizable;
					  beNotShrinkable ];
		  add: self canvasSectionLayout;
		  yourself
]
