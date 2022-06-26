Class {
	#name : #OPEditorLayout,
	#superclass : #Object,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPEditorLayout class >> all [

	^ self allSubclasses collect: #new
]

{ #category : #accessing }
OPEditorLayout class >> default [

	^ OPEditorPaletteLeftLayout new
]

{ #category : #accessing }
OPEditorLayout class >> named: aString [

	^ (self allSubclasses collect: #new) detect: [ :any | 
		  any name = aString ]
]

{ #category : #applying }
OPEditorLayout >> applyOn: anEditor [

	anEditor canvasPresenter needRebuild: false.
	^ anEditor layout: (self spLayoutFor: anEditor)
]

{ #category : #specs }
OPEditorLayout >> canvasSectionLayout [

	^ SpBoxLayout newTopToBottom
		  add: #canvasPresenter;
		  add: (SpBoxLayout newLeftToRight
				   add: #canvasMenu;
				   add: #zoomLabel expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #specs }
OPEditorLayout >> formSectionLayout [

	^ self scrollableTabWith: #form label: 'Properties'
]

{ #category : #accessing }
OPEditorLayout >> name [
^ self subclassResponsibility 
]

{ #category : #specs }
OPEditorLayout >> paletteSectionLayout [

	^ self scrollableTabWith: #palette label: 'Palette'
]

{ #category : #applying }
OPEditorLayout >> resizePanelsOf: aMorph afterWindowResized: aResizeEvent [

	^ self subclassResponsibility
]

{ #category : #specs }
OPEditorLayout >> scrollableTabWith: aContent label: aTabLabel [

	^ SpBoxLayout newTopToBottom
		  add: (OPTabHeaderPresenter labelled: aTabLabel) expand: false;
		  spacing: 10;
		  add: (SpScrollableLayout with: (SpBoxLayout newTopToBottom
						    add: aContent expand: false;
						    add: (SpLabelPresenter new
								     label: '';
								     yourself)
						    expand: false;
						    yourself));
		  yourself
]

{ #category : #applying }
OPEditorLayout >> spLayoutFor: anEditor [

	^ self subclassResponsibility
]
