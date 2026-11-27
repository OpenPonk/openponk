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
OPEditorPaletteRightLayout >> spLayoutFor: anEditor [
	"[ Canvas | Palette ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: OPPalette initialWidth negated;
		  add: self canvasSectionLayout;
		  add: self paletteSectionLayout withConstraints: [ :constraints |
				  constraints
					  beNotResizable;
					  beNotShrinkable ];
		  yourself
]
