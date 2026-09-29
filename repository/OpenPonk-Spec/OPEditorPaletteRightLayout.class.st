"
Concrete layout strategy for the OpenPonk editor that positions the creation palette on the right side of the diagram canvas.
"
Class {
	#name : 'OPEditorPaletteRightLayout',
	#superclass : 'OPEditorLayout',
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'accessing' }
OPEditorPaletteRightLayout >> name [

	^ 'Palette on right'
]

{ #category : 'applying' }
OPEditorPaletteRightLayout >> resizePanelsOf: aMorph afterWindowResized: aResizeEvent [

	| editorLayoutPolicy canvasPaletteLayoutPolicy diff canvasWidth canvasWithPaletteWidth paletteWidth paletteLackOfWidth |
	aResizeEvent newSize x < 500 ifTrue: [ ^ self ].

	diff := aResizeEvent newSize x - aResizeEvent oldSize x.

	editorLayoutPolicy := aMorph layoutPolicy.
	canvasPaletteLayoutPolicy := aMorph submorphs first layoutPolicy.

	canvasWithPaletteWidth := aMorph submorphs first extent x.
	canvasWidth := aMorph submorphs first submorphs first extent x.
	paletteWidth := aMorph submorphs first submorphs third extent x.
	paletteLackOfWidth := OPPalette minWidth - paletteWidth max: 0.

	editorLayoutPolicy position: canvasWithPaletteWidth + diff.
	canvasPaletteLayoutPolicy position:
		canvasWidth + diff - paletteLackOfWidth
]

{ #category : 'applying' }
OPEditorPaletteRightLayout >> spLayoutFor: anEditor [
	"[ Canvas | Palette ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: OPEditor canvasSectionWidth;
		  add: self canvasSectionLayout;
		  add: self paletteSectionLayout;
		  yourself
]
