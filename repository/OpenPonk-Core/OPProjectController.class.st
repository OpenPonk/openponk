"
I am not actually a controller, but I do manage a Project.
"
Class {
	#name : #OPProjectController,
	#superclass : #Object,
	#instVars : [
		'workbench',
		'project',
		'controllers',
		'lastSave',
		'disableAutosave',
		'persistenceManager'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #adding }
OPProjectController >> addDiagramController: aController [
	self subscribeTo: aController.
	controllers add: aController
]

{ #category : #saving }
OPProjectController >> autoSave: aMemento [
	disableAutosave
		ifTrue: [ ^ self ].
	lastSave ifNil: [ ^ self ].
	self project fileName ifNil: [ ^ self ].
	(lastSave at: #autosave)
		at: aMemento id asString
		put:
			(Dictionary
				with: #dateTime -> DateAndTime now truncated asString
				with: #graph -> (#OPFsmGraphML asClass new export: aMemento model withLayout: aMemento layout)).
	self saveState: lastSave to: self project fileName
]

{ #category : #accessing }
OPProjectController >> controllers [
	^ controllers
]

{ #category : #accessing }
OPProjectController >> enabledPlugins [
	^ OPPluginRegistry default plugins
]

{ #category : #opening }
OPProjectController >> ensureViewsLoaded [
	(project models isNotEmpty and: [ project views isEmpty ])
		ifTrue: [ | views |
			views := project models collect: [ :each | OPDiagramView defaultViewFor: each ].
			project views: views ]
]

{ #category : #adding }
OPProjectController >> hasModel: aModel [
	^ controllers anySatisfy: [ :each | each model = aModel ]
]

{ #category : #adding }
OPProjectController >> hasModel: aModel view: aDiagramView [
	^ controllers
		anySatisfy: [ :each | each model = aModel and: [ each diagramView = aDiagramView ] ]
]

{ #category : #testing }
OPProjectController >> hasView: aDiagramView [
	^ controllers anySatisfy: [ :each | each diagramView = aDiagramView ]
]

{ #category : #initialization }
OPProjectController >> initialize [
	super initialize.
	controllers := OrderedCollection new
]

{ #category : #'as yet unclassified' }
OPProjectController >> initializeProjectFolder: aFolder [
	(aFolder / 'models') ensureCreateDirectory
]

{ #category : #saving }
OPProjectController >> lastSave [
	^ lastSave
]

{ #category : #accessing }
OPProjectController >> layoutFor: aDiagram [
	^ project layoutFor: aDiagram
]

{ #category : #loading }
OPProjectController >> loadAutosave [
	| data save askForAutoSave |
	self project fileName ifNil: [ ^ self ].
	data := self loadStateFrom: self project fileName.
	save := DateAndTime fromString: (data at: #dateTime).
	askForAutoSave := (data at: #autosave)
		anySatisfy: [ :each | save < (DateAndTime fromString: (each value at: #dateTime)) ].
	(askForAutoSave
		and: [ UIManager default
				confirm: 'Newer autosaved version of diagram detected.' , String cr , 'Load?' ])
		ifTrue: [ (data at: #autosave)
				keysAndValuesDo: [ :key :value | 
					controllers
						detect: [ :each | each model uuid asString = key ]
						ifFound: [ :ctrl | 
							| dict |
							dict := #OPFsmGraphML asClass new import: (value at: #graph).
							ctrl persistenceManager
								saveState: (#OPFsmPersistenceMemento asClass model: (dict at: #model) layout: (dict at: #layout)).
							ctrl loadState: ctrl persistenceManager loadCurrent ] ] ]
]

{ #category : #loading }
OPProjectController >> loadStateFrom: aFile [
	^ STON fromStream: aFile readStream
]

{ #category : #saving }
OPProjectController >> modelMementoFor: aModel [
	^ controllers
		detect: [ :each | each model = aModel ]
		ifFound: #memento
		ifNone: [ OPPersistenceMemento model: aModel diagram: nil ]
]

{ #category : #saving }
OPProjectController >> modelMementos [
	^ self project models collect: [ :each | self modelMementoFor: each ]
]

{ #category : #saving }
OPProjectController >> newSaveData [
	lastSave := Dictionary
		with: #dateTime -> DateAndTime now truncated asString
		with: #project -> (Dictionary with: #name -> self project name)
		with: #autosave -> Dictionary new
		with: #diagrams -> self serializedDiagrams.
	^ lastSave
]

{ #category : #actions }
OPProjectController >> openFirstDiagram [
	disableAutosave := true.
	project models ifNotEmpty: [ workbench openEditorOn: project models first ].
	self loadAutosave.
	disableAutosave := false
]

{ #category : #opening }
OPProjectController >> openProject [
	FDOpenFileDialog new
		whenSelected: [ :file | self openProjectFromFile: file ];
		extensionFilters:
			{'OpenPonk projects' -> #('opp').
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		title: 'Select an OpenPonk project...';
		open
]

{ #category : #opening }
OPProjectController >> openProjectFromFile: aFile [
	| reader newProject store |
	store := OPZipPersistence new loadFrom: aFile.
	reader := OPPersistenceProjectReader new.
	newProject := reader fromFolder: store.
	newProject storageFile: aFile.
	newProject open
]

{ #category : #opening }
OPProjectController >> openProjectFromFolder: aFolder [
	| reader newProject |
	reader := OPPersistenceProjectReader new.
	newProject := reader fromFolder: aFolder.
	newProject open
]

{ #category : #opening }
OPProjectController >> openViews [
	| selected |
	self ensureViewsLoaded.
	selected := project views
		detect: [ :each | each isOpen & each isSelected ]
		ifNone: [ nil ].
	(project views sorted: #order ascending)
		select: #isOpen
		thenDo: [ :each | workbench openEditorOnView: each ].
	selected ifNotNil: [ workbench openEditorOnView: selected ].
	(project views isNotEmpty and: [ project views noneSatisfy: #isOpen ])
		ifTrue: [ workbench openEditorOnView: project views first ]
]

{ #category : #accessing }
OPProjectController >> persistLayouts [
	controllers do: [ :each | project layout: each layout for: each model ]
]

{ #category : #accessing }
OPProjectController >> persistenceManager [
	^ persistenceManager ifNil: [ persistenceManager := OPProjectDirectoryPersistence new ]
]

{ #category : #accessing }
OPProjectController >> project [
	^ project
]

{ #category : #accessing }
OPProjectController >> project: aProject [
	project := aProject.
	project fileName
		ifNotNil: [ lastSave := self loadStateFrom: project fileName.
			[ project models isNotEmpty ]
				whileTrue: [ project removeModel: project models anyOne ].
			(lastSave at: #models)
				valuesDo: [ :each | 
					| dict |
					dict := #OPFsmGraphML asClass new import: each.
					project addModel: (dict at: #model).
					project layout: (dict at: #layout) for: (dict at: #model) ] ]
]

{ #category : #accessing }
OPProjectController >> projectFile [
	self project storageFile
		ifNil: [ self project
				storageFile:
					(FDSaveFileDialog new
						extensionFilters:
							{'OpenPonk projects' -> #('opp').
							'All files' -> #()};
						defaultFolder: FileLocator imageDirectory asFileReference;
						openModal) ].
	^ self project storageFile
]

{ #category : #accessing }
OPProjectController >> projectFolder [
	self project storageFolder
		ifNil: [ self project
				storageFolder: (UIManager default chooseDirectory: 'Choose Directory where your project should be stored') ].
	^ self project storageFolder
]

{ #category : #removing }
OPProjectController >> removeDiagramController: aController [
	project layout: aController layout for: aController model.
	controllers remove: aController.
	self unsubscribeFrom: aController
]

{ #category : #saving }
OPProjectController >> saveProject [
	self projectFile ifNil: [ ^ self inform: 'Saving canceled' ].
	self project saveInImage.
	self saveProjectTo: self project storageFile.
	self inform: 'Project saved to ' , self project storageFile fullName
]

{ #category : #saving }
OPProjectController >> saveProjectTo: aFile [
	| store |
	store := FileSystem memory root.
	self persistenceManager
		saveProject: self project
		withMementos: self modelMementos
		to: store.
	OPZipPersistence new save: store to: aFile
]

{ #category : #saving }
OPProjectController >> saveState: saveData to: aFile [
	aFile
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (STON toJsonStringPretty: saveData) ]
]

{ #category : #saving }
OPProjectController >> serializedDiagrams [
	^ (controllers
		select: [ :each | each className = #OPFsmController ]
		thenCollect: [ :each | 
			each model uuid asString
				-> (#OPFsmGraphML asClass new export: each model withLayout: each layout) ])
		asDictionary
]

{ #category : #announcements }
OPProjectController >> subscribeTo: aDiagramController [
	aDiagramController model announcer
		when: OPOpenEditorRequest
		do: [ :ann | workbench openEditorOn: ann model ].
	aDiagramController model announcer
		when: OPCloseEditorRequest
		do: [ :ann | workbench closeEditorOf: ann model ]
]

{ #category : #announcements }
OPProjectController >> unsubscribeFrom: aDiagramController [
	aDiagramController model announcer unsubscribe: self
]

{ #category : #opening }
OPProjectController >> updateViews [
	| focusedController |
	focusedController := workbench focusedEditor
		ifNotNil: [ :editor | editor diagramController ].
	self project views
		do: [ :view | 
			view modelName: view model name.
			controllers
				detect: [ :ctrl | ctrl diagramView = view ]
				ifFound: [ :ctrl | 
					view isOpen: true.
					view layout: ctrl layout.
					view visibleElements: ctrl visibleElements.
					view updateFromRoassalView: ctrl view.
					view order: (controllers indexOf: ctrl).
					view isSelected: ctrl = focusedController ]
				ifNone: [ view
						isOpen: false;
						order: -1;
						isSelected: false ] ]
]

{ #category : #accessing }
OPProjectController >> workbench: aWorkbench [
	workbench := aWorkbench 
]
