Class {
	#name : #OPEditorPaletteRightLayout,
	#superclass : #OPEditorLayout,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPEditorPaletteRightLayout >> name [

	^ 'Palette on right'
]

{ #category : #applying }
OPEditorPaletteRightLayout >> resizePanelsOf: aMorph afterWindowResized: aResizeEvent [

	| editorFormLayoutPolicy canvasPaletteLayoutPolicy diff canvasWidth canvasWithPaletteWidth paletteWidth formWidth formLackOfWidth paletteLackOfWidth |
	
	diff := aResizeEvent newSize x - aResizeEvent oldSize x.
	
	editorFormLayoutPolicy := aMorph layoutPolicy.
	canvasPaletteLayoutPolicy := aMorph submorphs first layoutPolicy.
	
	canvasWithPaletteWidth := aMorph submorphs first extent x.
	canvasWidth := aMorph submorphs first submorphs first extent x.
	formWidth := aMorph submorphs third extent x.
	paletteWidth := aMorph submorphs first submorphs third extent x.
	formLackOfWidth := OPDynamicForm minWidth - formWidth max: 0.
	paletteLackOfWidth := OPPalette minWidth - paletteWidth max: 0.
	
	editorFormLayoutPolicy position:
		canvasWithPaletteWidth + diff - formLackOfWidth.
	canvasPaletteLayoutPolicy position:
		canvasWidth + diff - paletteLackOfWidth
]

{ #category : #applying }
OPEditorPaletteRightLayout >> spLayoutFor: anEditor [

	"[ [ Canvas | Palette ] | Form ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider:
			  anEditor canvasSectionWidth + OPPalette initialWidth;
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: anEditor canvasSectionWidth;
				   add: self canvasSectionLayout;
				   add: self paletteSectionLayout;
				   yourself);
		  add: self formSectionLayout;
		  yourself
]
