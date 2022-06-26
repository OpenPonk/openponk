Class {
	#name : #OPEditorPaletteLeftLayout,
	#superclass : #OPEditorLayout,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPEditorPaletteLeftLayout >> name [

	^ 'Palette on left'
]

{ #category : #applying }
OPEditorPaletteLeftLayout >> resizePanelsOf: aMorph afterWindowResized: aResizeEvent [

	| canvasFormlayoutPolicy canvasWidth formWidth formLackOfWidth diff |
	
	diff := aResizeEvent newSize x - aResizeEvent oldSize x.
	
	canvasFormlayoutPolicy := aMorph submorphs third layoutPolicy.
	
	canvasWidth := aMorph submorphs third submorphs first extent x.
	formWidth := aMorph submorphs third submorphs third extent x.
	formLackOfWidth := OPDynamicForm minWidth - formWidth max: 0.
	
	aMorph layoutPolicy position: aMorph submorphs first extent x.
	canvasFormlayoutPolicy position: canvasWidth + diff - formLackOfWidth
]

{ #category : #applying }
OPEditorPaletteLeftLayout >> spLayoutFor: anEditor [

	"[ Palette | [ Canvas | Form ] ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: OPPalette initialWidth;
		  add: self paletteSectionLayout
		  withConstraints: [ :constraints | 
			  constraints
				  beNotResizable;
				  beNotShrinkable ];
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: anEditor canvasSectionWidth;
				   add: self canvasSectionLayout
				   withConstraints: [ :constraints | 
					   constraints
						   beNotResizable;
						   beNotShrinkable ];
				   add: self formSectionLayout
				   withConstraints: [ :constraints | 
					   constraints
						   beNotResizable;
						   beNotShrinkable ];
				   yourself);
		  yourself
]
