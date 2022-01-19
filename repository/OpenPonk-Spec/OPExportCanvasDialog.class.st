Class {
	#name : #OPExportCanvasDialog,
	#superclass : #FDSaveFileDialog,
	#instVars : [
		'zoomLabel',
		'zoomText',
		'zoomPercentageLabel'
	],
	#category : #'OpenPonk-Spec'
}

{ #category : #specs }
OPExportCanvasDialog class >> defaultSpec [

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
OPExportCanvasDialog >> confirm [

	| zoomNumber file |
	file := self selectedEntry.
	file ifNil: [ ^ self ].
	zoomNumber := (NumberParser
		               parse: zoomText text
		               onError: [ 
		               TRCamera basicNew defaultCameraScale * 100 ]) / 100.
	zoomNumber < 0.01 ifTrue: [ 
		zoomNumber := TRCamera basicNew defaultCameraScale ].
	onConfirmBlock cull: file cull: zoomNumber.
	self delete
]

{ #category : #initialization }
OPExportCanvasDialog >> initializePresenter [

	super initializePresenter.
	self initializeZoom
]

{ #category : #initialization }
OPExportCanvasDialog >> initializeWidgets [

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
OPExportCanvasDialog >> initializeZoom [

	zoomText
		text: '100';
		whenTextIsAccepted: [ :text | 
			zoomText text: ((text select: #isDigit) takeFirst: 4) ]
]

{ #category : #accessing }
OPExportCanvasDialog >> zoomLabel [

	^ zoomLabel
]

{ #category : #accessing }
OPExportCanvasDialog >> zoomPercentageLabel [

	^ zoomPercentageLabel
]

{ #category : #accessing }
OPExportCanvasDialog >> zoomText [

	^ zoomText
]
