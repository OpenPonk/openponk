"
I am a form for saving a project --- a way to specify the project name and it's storage folder.
"
Class {
	#name : #OPSaveProjectWindow,
	#superclass : #ComposableModel,
	#instVars : [
		'projectNameLabel',
		'projectNameInput',
		'projectFolderLabel',
		'projectFolderInput',
		'projectFolderButton',
		'selectedFolder',
		'projectController'
	],
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPSaveProjectWindow class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				add: #projectNameLabel width: 100;
				add: #projectNameInput ]
			height: 22;
		newRow: [ :r | 
			r
				add: #projectFolderLabel width: 100;
				add: #projectFolderInput;
				add: #projectFolderButton width: 50 ]
			height: 44;
		newRow: [ :r |  ];
		yourself
]

{ #category : #'as yet unclassified' }
OPSaveProjectWindow class >> open [
	<script>
	^ self new open
]

{ #category : #actions }
OPSaveProjectWindow >> basicSave [
	projectController saveProject.
	self inform: 'Project saved'
]

{ #category : #actions }
OPSaveProjectWindow >> cancel [
	self inform: 'Save canceled'
]

{ #category : #actions }
OPSaveProjectWindow >> chooseFolder [
	FDOpenDirectoryDialog new
		whenSelected: [ :folder | 
			selectedFolder := folder fullName.
			self updateFolderInput ];
		open
]

{ #category : #api }
OPSaveProjectWindow >> initialExtent [
	^ 600 @ 300
]

{ #category : #initialization }
OPSaveProjectWindow >> initialize [
	selectedFolder := Smalltalk imageDirectory fullName.
	super initialize.
	projectNameInput text: 'New Project'
]

{ #category : #initialization }
OPSaveProjectWindow >> initializePresenter [
	projectNameInput whenTextChanged: [ :newValue | self updateFolderInput ].
	projectFolderButton action: [ self chooseFolder ]
]

{ #category : #initialization }
OPSaveProjectWindow >> initializeWidgets [
	(projectNameLabel := self newLabel) label: 'Project name'.
	(projectNameInput := self newTextInput) autoAccept: true.
	(projectFolderLabel := self newLabel) label: 'Project folder'.
	(projectFolderInput := self newTextInput) autoAccept: true.
	(projectFolderButton := self newButton) label: '...'
]

{ #category : #'instance creation' }
OPSaveProjectWindow >> open [
	projectController project storageFolder ifNotNil: [ ^ self basicSave ].
	self openDialogWithSpec
		okAction: [ self save ];
		cancelAction: [ self cancel ]
]

{ #category : #accessing }
OPSaveProjectWindow >> projectController: aProjectController [
	projectController := aProjectController.
	projectNameInput
		text: (projectController project name asLowercase copyReplaceAll: ' ' with: '-')
]

{ #category : #'accessing - spec fields' }
OPSaveProjectWindow >> projectFolderButton [
	^ projectFolderButton
]

{ #category : #'accessing - spec fields' }
OPSaveProjectWindow >> projectFolderInput [
	^ projectFolderInput
]

{ #category : #'accessing - spec fields' }
OPSaveProjectWindow >> projectFolderLabel [
	^ projectFolderLabel
]

{ #category : #'accessing - spec fields' }
OPSaveProjectWindow >> projectNameInput [
	^ projectNameInput
]

{ #category : #'accessing - spec fields' }
OPSaveProjectWindow >> projectNameLabel [
	^ projectNameLabel
]

{ #category : #actions }
OPSaveProjectWindow >> save [
	projectController project storageFolder: self projectFolderInput text.
	projectController project name: self projectNameInput text.
	self basicSave
]

{ #category : #api }
OPSaveProjectWindow >> title [
	^ 'Save project'
]

{ #category : #private }
OPSaveProjectWindow >> updateFolderInput [
	projectFolderInput text: selectedFolder , '/' , projectNameInput text asValidSelector
]
