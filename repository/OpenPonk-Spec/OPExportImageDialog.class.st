Class {
	#name : #OPExportImageDialog,
	#superclass : #OPExportCanvasDialog,
	#instVars : [
		'zoomLabel',
		'zoomText',
		'zoomPercentageLabel'
	],
	#category : #'OpenPonk-Spec'
}

{ #category : #specs }
OPExportImageDialog class >> defaultSpec [

	^ SpecColumnLayout composed
		  newRow: [ :r | 
			  r
				  newColumn: [ :c | c add: #bookmarksList ] width: 150;
				  newColumn: [ :c | 
					  c add: #currentFolderLabel height: self toolbarHeight.
					  c add: #filesList ] ];
		  newRow: [ :r | 
			  r
				  add: #nameLabel width: 50;
				  add: #nameText;
				  add: #filtersDropList width: 200 ]
		  height: self toolbarHeight;
		  newRow: [ :r | 
			  r
				  add: #zoomLabel width: 50;
				  add: #zoomText width: 40;
				  add: #zoomPercentageLabel.
			  r newColumn: [ :c |  ].
			  self dialogButtonsLayout: r ]
		  height: self toolbarHeight;
		  yourself
]

{ #category : #actions }
OPExportImageDialog >> confirm [

	| zoomNumber file |
	file := self selectedEntry.
	file ifNil: [ ^ self ].
	zoomNumber := (NumberParser
		               parse: zoomText text
		               onError: [ 
		               TRCamera basicNew defaultCameraScale * 100 ]) / 100.
	zoomNumber < 0.01 ifTrue: [ 
		zoomNumber := TRCamera basicNew defaultCameraScale ].

	self window close.
	onConfirmBlock cull: file cull: zoomNumber.
	self delete
]

{ #category : #initialization }
OPExportImageDialog >> initializePresenter [

	super initializePresenter.
	self initializeZoom
]

{ #category : #initialization }
OPExportImageDialog >> initializeWidgets [

	super initializeWidgets.
	(zoomLabel := self newLabel) label: 'Zoom: '.
	(zoomText := self newTextInput) autoAccept: true.
	(zoomPercentageLabel := self newLabel) label: ' %'.
	self focusOrder: { 
			nameText.
			filtersDropList.
			zoomText.
			cancelButton.
			confirmButton }
]

{ #category : #initialization }
OPExportImageDialog >> initializeZoom [

	zoomText
		text: '100';
		whenTextIsAccepted: [ :text | 
			zoomText text: ((text select: #isDigit) takeFirst: 4) ]
]

{ #category : #accessing }
OPExportImageDialog >> zoomLabel [

	^ zoomLabel
]

{ #category : #accessing }
OPExportImageDialog >> zoomPercentageLabel [

	^ zoomPercentageLabel
]

{ #category : #accessing }
OPExportImageDialog >> zoomText [

	^ zoomText
]
