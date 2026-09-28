"
Tests canvas zoom controls, scale factor adjustments, and button event propagation in the zoom toolbar.
"
Class {
	#name : 'OPZoomToolbarPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvasPresenter',
		'toolbarPresenter'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPZoomToolbarPresenterTest >> setUp [
	"Prepares the canvas presenter and initializes the zoom toolbar presenter with explicit model binding."

	super setUp.
	canvasPresenter := OPCanvasPresenter newApplication: SpApplication defaultApplication.
	toolbarPresenter := OPZoomToolbarPresenter
		newApplication: SpApplication defaultApplication
		model: canvasPresenter
]

{ #category : 'running' }
OPZoomToolbarPresenterTest >> tearDown [
	toolbarPresenter ifNotNil: [ :activeToolbarPresenter | 
		activeToolbarPresenter withWindowDo: [ :windowMorph | windowMorph close ] ].
	canvasPresenter ifNotNil: [ :activeCanvasPresenter | 
		activeCanvasPresenter withWindowDo: [ :windowMorph | windowMorph close ] ].
	super tearDown
]

{ #category : 'tests' }
OPZoomToolbarPresenterTest >> testInitialValues [
	"Verifies initial presence of all viewport buttons and correct default labels."
	self assert: toolbarPresenter zoomOutButton isNotNil.
	self assert: toolbarPresenter zoomValueButton isNotNil.
	self assert: toolbarPresenter zoomInButton isNotNil.
	self assert: toolbarPresenter zoomFitButton isNotNil.
	self assert: toolbarPresenter zoomValueButton label equals: '100%'.
	self assert: toolbarPresenter zoomFitButton label equals: 'Zoom to Fit'
]

{ #category : 'tests' }
OPZoomToolbarPresenterTest >> testZoomInAction [
	"Verifies zoom in scaling step."
	canvasPresenter zoom: 1.0.
	toolbarPresenter zoomIn.
	self assert: canvasPresenter zoom equals: 1.25
]

{ #category : 'tests' }
OPZoomToolbarPresenterTest >> testZoomLabelUpdatesWhenScaleChanges [
	"Verifies reactive update of zoom value label upon canvas camera changes."
	canvasPresenter zoom: 1.5.
	self assert: toolbarPresenter zoomValueButton label equals: '150%'.
	canvasPresenter zoom: 0.5.
	self assert: toolbarPresenter zoomValueButton label equals: '50%'
]

{ #category : 'tests' }
OPZoomToolbarPresenterTest >> testZoomOutAction [
	"Verifies zoom out scaling step."
	canvasPresenter zoom: 1.0.
	toolbarPresenter zoomOut.
	self assert: canvasPresenter zoom equals: 0.8
]

{ #category : 'tests' }
OPZoomToolbarPresenterTest >> testZoomResetAction [
	"Verifies clicking zoom value resets scale to 1.0."
	canvasPresenter zoom: 1.5.
	toolbarPresenter zoomReset.
	self assert: canvasPresenter zoom equals: 1.0.
	self assert: toolbarPresenter zoomValueButton label equals: '100%'
]
