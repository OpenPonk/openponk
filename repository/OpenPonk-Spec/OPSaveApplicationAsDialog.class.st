Class {
	#name : #OPSaveApplicationAsDialog,
	#superclass : #ComposablePresenter,
	#instVars : [
		'locationText',
		'directoryButton',
		'fileButton',
		'location',
		'projectController',
		'newStorage',
		'onSave'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #specs }
OPSaveApplicationAsDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #locationText height: self toolbarHeight * 2;
		newRow: [ :r |  ];
		newRow: [ :r | 
			r
				add: #directoryButton;
				add: #fileButton ]
			height: self toolbarHeight * 2;
		yourself
]

{ #category : #examples }
OPSaveApplicationAsDialog class >> example [
	| storage projectController project |
	storage := NSPApplicationStructuredStorage appName: 'breakingApp' version: '1.0'.
	storage beFileBased.
	project := storage asNSPProject.
	(projectController := project controllerClass new) project: project.
	self openOn: storage onSave: [ :newStorage | newStorage inspect ]
]

{ #category : #'instance creation' }
OPSaveApplicationAsDialog class >> openOn: aStorage onSave: aOneArgBlock [
	^ self new
		startOn: aStorage onSave: aOneArgBlock;
		openWithSpec
]

{ #category : #'accessing - spec fields' }
OPSaveApplicationAsDialog >> directoryButton [
	^ directoryButton
]

{ #category : #'accessing - spec fields' }
OPSaveApplicationAsDialog >> fileButton [
	^ fileButton
]

{ #category : #api }
OPSaveApplicationAsDialog >> initialExtent [
	^ 600 @ 200
]

{ #category : #initialization }
OPSaveApplicationAsDialog >> initializeWidgets [
	onSave := [ :aStorage |  ].
	locationText := self newText.
	directoryButton := self newButton
		label: 'Save As Directory';
		action: [ newStorage beDirectoryBased.
			onSave value: newStorage.
			self delete ].
	fileButton := self newButton
		label: 'Save As File';
		action: [ newStorage beFileBased.
			onSave value: newStorage.
			self delete ]
]

{ #category : #'accessing - spec fields' }
OPSaveApplicationAsDialog >> locationText [
	^ locationText
]

{ #category : #building }
OPSaveApplicationAsDialog >> startOn: aStorage onSave: aOneArgBlock [
	| currentButton |
	newStorage := aStorage class fromPath: aStorage applicationXmlFile.
	onSave := aOneArgBlock.
	currentButton := (aStorage isDirectoryBased ifNil: [ aStorage detectIsDirectoryBased ])
		ifTrue: [ directoryButton ]
		ifFalse: [ fileButton ].
	currentButton label: currentButton label , ' (current)'.
	locationText text: newStorage applicationXmlFile fullName
]

{ #category : #api }
OPSaveApplicationAsDialog >> title [
	^ 'Save Application As...'
]
