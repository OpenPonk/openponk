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

{ #category : #'instance creation' }
OPProjectController class >> fromDirectory: aFolder [
	^ OPProjectDirectoryMaterializer new
		loadProjectFrom: aFolder asFileReference
]

{ #category : #'instance creation' }
OPProjectController class >> fromFile: aFile [
	| newProject store |
	store := OPZipPersistence new loadFrom: aFile asFileReference.
	newProject := self fromDirectory: store / 'project'.
	newProject storageFile: aFile asFileReference.
	^ newProject
]

{ #category : #opening }
OPProjectController class >> openFromFile [
	FDOpenFileDialog new
		whenSelected: [ :file | self openFromFile: file ];
		extensionFilters:
			{'OpenPonk projects' -> #('opp').
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		title: 'Select an OpenPonk project...';
		open
]

{ #category : #'instance creation' }
OPProjectController class >> openFromFile: aFile [
	^ (self fromFile: aFile)
		open;
		yourself
]

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
			(controllers
				select: [ :each | each model = aModel ]
				thenCollect: [ :each | each diagram ])
]

{ #category : #saving }
OPProjectController >> modelMementos [
	^ self project models collect: [ :each | self modelMementoFor: each ]
]

{ #category : #opening }
OPProjectController >> openDiagrams [
	| selected |
	project ensureModelsHaveDiagrams.
	selected := project diagrams
		detect: [ :each | each isOpen & each isSelected ]
		ifNone: [ nil ].
	(project diagrams sorted: #order ascending)
		select: #isOpen
		thenDo: [ :each | workbench openEditorOnDiagram: each ].
	selected ifNotNil: [ workbench openEditorOnDiagram: selected ].
	(project diagrams isNotEmpty
		and: [ project diagrams noneSatisfy: #isOpen ])
		ifTrue: [ project diagrams
				do: [ :eachDiagram | workbench openEditorOnDiagram: eachDiagram ] ]
]

{ #category : #opening }
OPProjectController >> openEditorOnDiagram: aDiagram [
	workbench openEditorOnDiagram: aDiagram
]

{ #category : #accessing }
OPProjectController >> persistenceManager [
	^ persistenceManager ifNil: [ persistenceManager := OPProjectDirectorySerializer new ]
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
	(self project storageFile isNil
		or: [ self project storageFile exists not
				or: [ self project storageFile isWritable not ] ])
		ifTrue: [ self project
				storageFile:
					(FDSaveFileDialog new
						extensionFilters:
							{('OpenPonk projects' -> #('opp')).
							('All files' -> #())};
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
OPProjectController >> removeDiagram: aDiagram [
	project removeDiagram: aDiagram.
	self
		removeDiagramController:
			(controllers
				detect: [ :any | any diagram = aDiagram ]
				ifNone: [ ^ self ])
]

{ #category : #removing }
OPProjectController >> removeDiagramController: aController [
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

{ #category : #accessing }
OPProjectController >> saveProjectAs [
	self project
		storageFile:
			(FDSaveFileDialog new
				extensionFilters:
					{('OpenPonk projects' -> #('opp')).
					('All files' -> #())};
				defaultFolder: FileLocator imageDirectory asFileReference;
				openModal).
	self saveProject
]

{ #category : #saving }
OPProjectController >> saveProjectTo: aFile [
	| store projectDirectory |
	store := FileSystem memory root.
	projectDirectory := store / 'project'.
	projectDirectory ensureCreateDirectory.
	self recentProjects at: self project uuid put: aFile.
	self updateDiagrams.
	self persistenceManager
		directory: projectDirectory;
		saveProject: self project withMementos: self modelMementos.
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
OPProjectController >> updateDiagram: aDiagram [
	controllers
		detect: [ :ctrl | ctrl diagram = aDiagram ]
		ifFound: [ :ctrl | 
			aDiagram isOpen: true.
			aDiagram layout: ctrl layout copy.
			aDiagram visibleElements: ctrl visibleElements copy.
			aDiagram commonElements: ctrl commonElements.
			aDiagram updateFromRoassalView: ctrl view.
			aDiagram order: (controllers indexOf: ctrl) ]
		ifNone: [ aDiagram
				isOpen: false;
				order: -1;
				isSelected: false ]
]

{ #category : #opening }
OPProjectController >> updateDiagrams [
	| focusedController |
	focusedController := workbench focusedEditor
		ifNotNil: [ :editor | editor diagramController ].
	self project diagrams
		do: [ :eachDiagram | 
			controllers
				detect: [ :ctrl | ctrl diagram = eachDiagram ]
				ifFound: [ :ctrl | 
					eachDiagram isOpen: true.
					eachDiagram layout: ctrl layout copy.
					eachDiagram commonElements: ctrl commonElements.
					eachDiagram visibleElements: ctrl visibleElements copy.
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
