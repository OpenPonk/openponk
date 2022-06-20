Class {
	#name : #OPExportImageDialog,
	#superclass : #StFBSaveFileDialog,
	#instVars : [
		'zoomLabel',
		'zoomText',
		'zoomPercentageLabel'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #'as yet unclassified' }
OPExportImageDialog class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: SpBoxLayout newLeftToRight:  [ :r | 
			  r
				  add: SpBoxLayout newTopToBottom:  [ :c | c add: #bookmarksList ] width: 150;
				  add: SpBoxLayout newTopToBottom:  [ :c | 
					  c add: #currentFolderLabel height: self toolbarHeight.
					  c add: #filesList ] ];
		  add: SpBoxLayout newLeftToRight:  [ :r | 
			  r
				  add: #nameLabel width: 50;
				  add: #nameText;
				  add: #filtersDropList width: 200 ]
		  height: self toolbarHeight;
		  add: SpBoxLayout newLeftToRight:  [ :r | 
			  r
				  add: #zoomLabel width: 50;
				  add: #zoomText width: 40;
				  add: #zoomPercentageLabel.
			  r add: SpBoxLayout newTopToBottom:  [ :c |  ].
			  self dialogButtonsLayout: r ]
		  height: self toolbarHeight;
		  yourself
]

{ #category : #specs }
OPExportImageDialog class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
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

	okAction cull: file cull: zoomNumber
]

{ #category : #actions }
OPExportImageDialog >> connectPresenters [

	super connectPresenters.
	self initializeZoom
]

{ #category : #actions }
OPExportImageDialog >> initializePresenters [

	super initializePresenters.
	(zoomLabel := self newLabel) label: 'Zoom: '.
	(zoomText := self newTextInput) autoAccept: true.
	(zoomPercentageLabel := self newLabel) label: ' %'
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
