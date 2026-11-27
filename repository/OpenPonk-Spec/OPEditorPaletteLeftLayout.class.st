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
