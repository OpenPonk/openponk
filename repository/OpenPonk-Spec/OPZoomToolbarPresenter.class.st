"
A Spec presenter providing visual zoom controls (zoom in, zoom out, fit to screen, reset) for the diagram canvas.
"
Class {
	#name : 'OPZoomToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'canvasPresenter',
		'zoomOutButton',
		'zoomValueButton',
		'zoomInButton',
		'zoomFitButton'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'accessing' }
OPZoomToolbarPresenter >> canvasPresenter [
	"Answers the canvas presenter managed by this zoom toolbar."

	^ canvasPresenter
]

{ #category : 'accessing' }
OPZoomToolbarPresenter >> canvasPresenter: aCanvasPresenter [
	"Sets the canvas presenter and subscribes to its zoom announcement events."

	canvasPresenter := aCanvasPresenter.
	self registerZoomAnnouncements
]

{ #category : 'initialization' }
OPZoomToolbarPresenter >> connectPresenters [
	"Connects presenter events and hooks canvas zoom announcements to update the zoom button label."

	super connectPresenters.
	self registerZoomAnnouncements
]

{ #category : 'layout' }
OPZoomToolbarPresenter >> defaultLayout [
	"Answers the compact horizontal box layout accommodating all four viewport navigation buttons."

	^ SpBoxLayout newLeftToRight
		spacing: 2;
		add: zoomOutButton width: 28;
		add: zoomValueButton width: 54;
		add: zoomInButton width: 28;
		add: zoomFitButton width: 110;
		yourself
]

{ #category : 'initialization' }
OPZoomToolbarPresenter >> initializePresenters [
	"Initializes the four flat zoom control buttons with their respective icons, actions, and tooltips."

	super initializePresenters.
	zoomOutButton := self newButton.
	zoomOutButton
		addStyle: 'flat';
		icon: OPIdeaGraphIcons zoomOutIcon;
		help: 'Zoom out';
		action: [ self zoomOut ].
	zoomValueButton := self newButton.
	zoomValueButton
		addStyle: 'flat';
		label: '100%';
		help: 'Reset zoom to 100%';
		action: [ self zoomReset ].
	zoomInButton := self newButton.
	zoomInButton
		addStyle: 'flat';
		icon: OPIdeaGraphIcons zoomInIcon;
		help: 'Zoom in';
		action: [ self zoomIn ].
	zoomFitButton := self newButton.
	zoomFitButton
		addStyle: 'flat';
		icon: OPIdeaGraphIcons fitContentIcon;
		label: 'Zoom to Fit';
		help: 'Fit all diagram elements into view';
		action: [ self zoomFit ].
	self focusOrder
		add: zoomOutButton;
		add: zoomValueButton;
		add: zoomInButton;
		add: zoomFitButton
]

{ #category : 'initialization' }
OPZoomToolbarPresenter >> registerZoomAnnouncements [
	"Registers a listener for zoom changes on the canvas presenter to dynamically update the zoom value button."

	canvasPresenter whenZoomChanged: [ :aZoomChangedAnnouncement |
		self updateZoomLabelFromScale: aZoomChangedAnnouncement newScale ]
]

{ #category : 'accessing - model' }
OPZoomToolbarPresenter >> setModelBeforeInitialization: aCanvasPresenter [
	"Sets the mandatory canvas presenter before presenter initialization commences."

	canvasPresenter := aCanvasPresenter
]

{ #category : 'updating' }
OPZoomToolbarPresenter >> updateZoomLabelFromScale: aScaleNumber [
	"Updates the zoom value button label with the rounded percentage representation of the provided scale factor."

	zoomValueButton label: (aScaleNumber * 100) rounded asString , '%'
]

{ #category : 'actions' }
OPZoomToolbarPresenter >> zoomFit [
	"Adjusts camera zoom and position to fit all diagram elements inside the viewport."

	canvasPresenter zoomToFit
]

{ #category : 'accessing' }
OPZoomToolbarPresenter >> zoomFitButton [
	"Answers the button that fits all diagram elements into the canvas view."

	^ zoomFitButton
]

{ #category : 'actions' }
OPZoomToolbarPresenter >> zoomIn [
	"Increases canvas zoom by multiplying the current scale factor by 1.25."

	canvasPresenter zoom: canvasPresenter zoom * 1.25
]

{ #category : 'accessing' }
OPZoomToolbarPresenter >> zoomInButton [
	"Answers the button that increases canvas zoom."

	^ zoomInButton
]

{ #category : 'actions' }
OPZoomToolbarPresenter >> zoomOut [
	"Decreases canvas zoom by multiplying the current scale factor by 0.8."

	canvasPresenter zoom: canvasPresenter zoom * 0.8
]

{ #category : 'accessing' }
OPZoomToolbarPresenter >> zoomOutButton [
	"Answers the button that decreases canvas zoom."

	^ zoomOutButton
]

{ #category : 'actions' }
OPZoomToolbarPresenter >> zoomReset [
	"Resets canvas zoom scale to 1.0 (100%) and updates the value button label accordingly."

	canvasPresenter zoom: 1.0.
	zoomValueButton label: '100%'
]

{ #category : 'accessing' }
OPZoomToolbarPresenter >> zoomValueButton [
	"Answers the button displaying current zoom percentage and resetting zoom on click."

	^ zoomValueButton
]
