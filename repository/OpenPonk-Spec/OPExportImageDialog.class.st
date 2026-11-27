"
Spec presenter extending standard save-file dialogs to support diagram exports. Injects custom controls, such as zoom and scale percentage configurations, to adjust the output image before saving.
"
Class {
	#name : 'OPExportImageDialog',
	#superclass : 'StSaveFilePresenter',
	#instVars : [
		'zoomLabel',
		'zoomText',
		'zoomPercentageLabel'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'actions' }
OPExportImageDialog >> confirmed [

	| zoomNumber file |
	file := self selectedEntry.
	file ifNil: [ ^ self ].
	zoomNumber := (NumberParser
		               parse: zoomText text
		               onError: [ RSCamera new scale * 100 ]) / 100.
	zoomNumber < 0.01 ifTrue: [ zoomNumber := RSCamera new scale ].

	okAction cull: file cull: zoomNumber
]

{ #category : 'initialization' }
OPExportImageDialog >> connectPresenters [

	super connectPresenters.
	self initializeZoom
]

{ #category : 'layout' }
OPExportImageDialog >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: super defaultLayout;
		  add: (SpBoxLayout newLeftToRight
				   add: SpNullPresenter new;
				   add: zoomLabel expand: false;
				   add: zoomText width: 30;
				   add: zoomPercentageLabel expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'initialization' }
OPExportImageDialog >> initializePresenters [

	super initializePresenters.
	(zoomLabel := self newLabel) label: 'Zoom: '.
	zoomText := self newTextInput.
	(zoomPercentageLabel := self newLabel) label: ' %'
]

{ #category : 'initialization' }
OPExportImageDialog >> initializeZoom [

	zoomText
		text: '100';
		whenTextChangedDo: [ :text |
				| digits sanitized |
				digits := text select: #isDigit.
				sanitized := digits first: (4 min: digits size).
				sanitized = text ifFalse: [
							zoomText property: #text rawValue: sanitized.
							zoomText withAdapterDo: [ :zoomAdapter | zoomAdapter widget setText: sanitized ] ] ]
]

{ #category : 'accessing' }
OPExportImageDialog >> zoomLabel [

	^ zoomLabel
]

{ #category : 'accessing' }
OPExportImageDialog >> zoomPercentageLabel [

	^ zoomPercentageLabel
]

{ #category : 'accessing' }
OPExportImageDialog >> zoomText [

	^ zoomText
]
