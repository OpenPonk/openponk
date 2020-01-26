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
	#classVars : [
		'RecentProjects'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #adding }
OPProjectController >> addDiagramController: aController [
	self subscribeTo: aController.
	controllers add: aController
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
OPProjectController >> ensureDiagramsLoaded [
	(project models isNotEmpty and: [ project diagrams isEmpty ])
		ifTrue: [ OPDiagramsReader new loadDiagramsOn: project ]
]

{ #category : #testing }
OPProjectController >> hasDiagram: aDiagram [
	^ controllers anySatisfy: [ :each | each diagram = aDiagram ]
]

{ #category : #adding }
OPProjectController >> hasModel: aModel [
	^ controllers anySatisfy: [ :each | each model = aModel ]
]

{ #category : #adding }
OPProjectController >> hasModel: aModel diagram: aDiagram [
	^ controllers
		anySatisfy: [ :each | each model = aModel and: [ each diagram = aDiagram ] ]
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

{ #category : #loading }
OPProjectController >> loadStateFrom: aFile [
	^ STON fromStream: aFile readStream
]

{ #category : #saving }
OPProjectController >> modelMementoFor: aModel [
	^ OPPersistenceMemento
		model: aModel
		diagrams:
			((controllers
				select: [ :each | each model = aModel ]
				thenCollect: [ :each | each diagram ])
				ifEmpty: [ OPDiagram defaultDiagramFor: aModel ])
]

{ #category : #saving }
OPProjectController >> modelMementos [
	^ self project models collect: [ :each | self modelMementoFor: each ]
]

{ #category : #opening }
OPProjectController >> openDiagrams [
	| selected |
	self ensureDiagramsLoaded.
	selected := project diagrams
		detect: [ :each | each isOpen & each isSelected ]
		ifNone: [ nil ].
	(project diagrams sorted: #order ascending)
		select: #isOpen
		thenDo: [ :each | workbench openEditorOnDiagram: each ].
	selected ifNotNil: [ workbench openEditorOnDiagram: selected ].
	(project diagrams isNotEmpty and: [ project diagrams noneSatisfy: #isOpen ])
		ifTrue: [ workbench openEditorOnDiagram: project diagrams first ]
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
	| newProject |
	newProject := OPPersistenceProjectReader new fromFolder: aFolder.
	^ newProject open
]

{ #category : #accessing }
OPProjectController >> persistenceManager [
	^ persistenceManager ifNil: [ persistenceManager := OPProjectPersistence new ]
]

{ #category : #accessing }
OPProjectController >> project [
	^ project
]

{ #category : #accessing }
OPProjectController >> project: aProject [
	project := aProject
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

{ #category : #accessing }
OPProjectController >> recentProjects [
	^ RecentProjects ifNil: [ RecentProjects := OrderedDictionary new ]
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
	self recentProjects at: self project uuid put: aFile.
	self updateViews.
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

{ #category : #'diagram selecting' }
OPProjectController >> selectInDiagram: aModelElement [
	controllers
		do: [ :dctrl | 
			dctrl controllers
				do: [ :ctrl | 
					ctrl model = aModelElement
						ifTrue: [ | palette |
							palette := dctrl editor paletteModel.
							palette selectSelectionTool selectedTool targetSelected: ctrl.
							dctrl editor canvasModel roassalView canvas camera
								translateTo: ctrl figure position.
							^ self ] ] ]
]

{ #category : #announcements }
OPProjectController >> subscribeTo: aDiagramController [
	aDiagramController model announcer
		when: OPOpenEditorRequest
		do: [ :ann | workbench openEditorOn: ann model ].
	aDiagramController model announcer
		when: OPCloseEditorRequest
		do: [ :ann | workbench closeEditorOf: ann model ].
	aDiagramController model announcer
		when: OPSelectDiagramElement
		do: [ :ann | self selectInDiagram: ann model ]
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
	self project diagrams
		do: [ :eachDiagram | 
			eachDiagram modelName: eachDiagram model name.
			controllers
				detect: [ :ctrl | ctrl diagram = eachDiagram ]
				ifFound: [ :ctrl | 
					eachDiagram isOpen: true.
					eachDiagram layout: ctrl layout.
					eachDiagram visibleElements: ctrl visibleElements.
					eachDiagram updateFromRoassalView: ctrl view.
					eachDiagram order: (controllers indexOf: ctrl).
					eachDiagram isSelected: ctrl = focusedController ]
				ifNone: [ eachDiagram
						isOpen: false;
						order: -1;
						isSelected: false ] ]
]

{ #category : #accessing }
OPProjectController >> workbench: aWorkbench [
	workbench := aWorkbench 
]
