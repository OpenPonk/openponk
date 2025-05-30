"
I am not actually a controller, but I do manage a Project.
"
Class {
	#name : 'OPProjectController',
	#superclass : 'Object',
	#instVars : [
		'workbench',
		'project',
		'controllers',
		'lastSave',
		'disableAutosave',
		'persistenceManager',
		'navigatorAdapters'
	],
	#classVars : [
		'RecentProjects'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'instance creation' }
OPProjectController class >> fromDirectory: aFolder [

	| materializer |
	materializer := aFolder files
		                detect: [ :any |
		                any basename = OPExportInfo fileName ]
		                ifFound: [ :exportInfoFile |
		                OPSerializer forExportInfoFile: exportInfoFile ]
		                ifNone: [ OPProjectDirectoryMaterializer new ].
	^ materializer loadProjectFrom: aFolder asFileReference
]

{ #category : 'opening' }
OPProjectController class >> fromDirectoryDo: aBlock [

	StOpenDirectoryPresenter new
		title: 'Choose an OpenPonk project directory';
		okAction: [ :dir | aBlock value: (self fromDirectory: dir) ];
		open
]

{ #category : 'instance creation' }
OPProjectController class >> fromFile: aFile [

	| newProject store aFileReference |
	aFileReference := aFile asFileReference.
	store := OPZipPersistence new loadFrom: aFileReference.
	newProject := self fromDirectory: store / 'project'.
	newProject storageFile: aFileReference.
	^ newProject
]

{ #category : 'opening' }
OPProjectController class >> fromFileDo: aBlock [

	StOpenFilePresenter new
		title: 'Choose an OpenPonk project';
		okAction: [ :file | aBlock value: (self fromFile: file) ];
		extensions: #( opp ) named: 'OP projects';
		open
]

{ #category : 'opening' }
OPProjectController class >> modalFromFile [

	^ StOpenFilePresenter new
		  title: 'Choose an OpenPonk project';
		  extensions: #( opp ) named: 'OP projects';
		  openModal
]

{ #category : 'opening' }
OPProjectController class >> openFromFile [

	self fromFileDo: [ :project | project open ]
]

{ #category : 'opening' }
OPProjectController class >> openModalFromFile [

	^ (self fromFile: (self modalFromFile ifNil: [ ^ nil ])) open
		  projectController
]

{ #category : 'adding' }
OPProjectController >> addDiagramController: aController [
	controllers add: aController
]

{ #category : 'saving' }
OPProjectController >> canProjectBeSavedToFile: aFileReference [
	aFileReference ifNil: [ ^ false ].
	[ aFileReference createFile ]
		on: Error
		do: [ ^ false ].
	aFileReference size isZero
		ifTrue: [ aFileReference delete ].
	^ true
]

{ #category : 'accessing' }
OPProjectController >> controllers [
	^ controllers
]

{ #category : 'accessing' }
OPProjectController >> enabledPlugins [
	^ OPPluginRegistry default plugins
]

{ #category : 'testing' }
OPProjectController >> hasDiagram: aDiagram [

	^ controllers anySatisfy: [ :each | each diagramElement = aDiagram ]
]

{ #category : 'adding' }
OPProjectController >> hasModel: aModel [

	^ project hasModel: aModel
]

{ #category : 'adding' }
OPProjectController >> hasModel: aModel diagram: aDiagram [
	^ controllers
		anySatisfy: [ :each | each model = aModel and: [ each diagram = aDiagram ] ]
]

{ #category : 'initialization' }
OPProjectController >> initialize [
	super initialize.
	controllers := OrderedCollection new
]

{ #category : 'saving' }
OPProjectController >> initializeProjectFolder: aFolder [
	(aFolder / 'models') ensureCreateDirectory
]

{ #category : 'saving' }
OPProjectController >> lastSave [
	^ lastSave
]

{ #category : 'loading' }
OPProjectController >> loadStateFrom: aFile [
	^ STON fromStream: aFile readStream
]

{ #category : 'merging' }
OPProjectController >> mergeFrom: aFile [

	self mergeWith: (self class fromFile: aFile)
]

{ #category : 'merging' }
OPProjectController >> mergeFromFile [

	self class fromFileDo: [ :otherProject | 
		self mergeWith: otherProject ]
]

{ #category : 'merging' }
OPProjectController >> mergeModelsAndDiagramsIntoOne [

	| showError plugins models plugin |
	showError := [ :text |
	             ^ (GrowlMorph
		                label: 'Unable to merge models'
		                contents: text)
		               backgroundColor:
			               GrowlMorph theme dangerBackgroundColor;
		               labelColor: GrowlMorph theme textColor;
		               textColor:
			               GrowlMorph theme textColorForNonStandardBackground;
		               openInWorld ].
	models := self project models.
	models ifEmpty: [ ^ showError value: 'There are no models' ].
	(self project diagrams size < 2 and: [ models size < 2 ]) ifTrue: [
		^ showError value:
			  'The model is as merged as it can be - there have to be at least 2 models or 2 diagrams' ].
	plugins := models collect: [ :each |
		           OPPluginRegistry default pluginFor: each ].
	plugins asSet size = 1 ifFalse: [
		^ showError value:
			  'All models must be of the same type/metamodel/plugin' ].
	plugin := plugins anyOne.
	plugin supportsMergingModels ifFalse: [
		^ showError value: 'Plugin of these models does not support merging' ].

	SpConfirmDialog new
		title: 'Merge all models and diagrams into one?';
		label:
			'This is irreversible and original models and diagrams will be lost.';
		acceptLabel: 'Yes, merge them';
		cancelLabel: 'Cancel';
		onAccept: [
			| model diagram layouter |
			model := plugin mergeModels: models.
			self project diagrams do: [ :eachDiagram |
					workbench closeEditorOfDiagram: eachDiagram ].
			models do: [ :eachModel | self removeModel: eachModel ].
			diagram := OPOpenPonkDiagram forModelElement: model.
			diagram ownedElements:
					(self project diagrams flatCollect: #ownedElements).
			self project addDiagram: diagram.
			layouter := (self openEditorOnDiagram: diagram) diagramController
				            layouter.
			layouter dominanceTreeLayout ];
		openDialog
]

{ #category : 'merging' }
OPProjectController >> mergeWith: aProject [

	| otherProjectDiagrams |
	otherProjectDiagrams := aProject diagrams.
	project mergeWith: aProject.
	otherProjectDiagrams do: [ :each | self openEditorOnDiagram: each ]
]

{ #category : 'saving' }
OPProjectController >> modelMementoFor: aModel [

	^ OPMemento model: aModel diagrams: (project diagramsOf: aModel)
]

{ #category : 'saving' }
OPProjectController >> modelMementos [
	^ self project models collect: [ :each | self modelMementoFor: each ]
]

{ #category : 'accessing' }
OPProjectController >> navigatorAdapters [

	^ navigatorAdapters ifNil: [ OPNavigatorAdapters new ]
]

{ #category : 'opening' }
OPProjectController >> openDiagrams [

	| selected |
	project ensureModelsHaveDiagrams.
	selected := project diagrams
		            detect: [ :each | each isOpen & each isSelected ]
		            ifNone: [ nil ].
	project diagrams
		select: #isOpen
		thenDo: [ :each | workbench openEditorOnDiagram: each ].
	selected ifNotNil: [ workbench openEditorOnDiagram: selected ].
	(project diagrams isNotEmpty and: [ 
		 project diagrams noneSatisfy: #isOpen ]) ifTrue: [ 
		project diagrams do: [ :eachDiagram | 
			workbench openEditorOnDiagram: eachDiagram ] ]
]

{ #category : 'opening' }
OPProjectController >> openEditorOnDiagram: aDiagram [

	^ workbench openEditorOnDiagram: aDiagram
]

{ #category : 'accessing' }
OPProjectController >> persistenceManager [
	^ persistenceManager ifNil: [ persistenceManager := OPProjectDirectorySerializer new ]
]

{ #category : 'accessing' }
OPProjectController >> project [
	^ project
]

{ #category : 'accessing' }
OPProjectController >> project: aProject [
	project := aProject
]

{ #category : 'accessing' }
OPProjectController >> projectFolder [
	self project storageFolder
		ifNil: [ self project
				storageFolder:
					(UIManager default
						chooseDirectory: 'Choose Directory where your project should be stored') ].
	^ self project storageFolder
]

{ #category : 'accessing' }
OPProjectController >> recentProjects [
	^ RecentProjects ifNil: [ RecentProjects := OrderedDictionary new ]
]

{ #category : 'removing' }
OPProjectController >> removeDiagram: aDiagram [

	project removeDiagram: aDiagram.
	self removeDiagramController: (controllers
			 detect: [ :any | any diagramElement = aDiagram ]
			 ifNone: [ ^ self ])
]

{ #category : 'removing' }
OPProjectController >> removeDiagramController: aController [

	controllers remove: aController
]

{ #category : 'removing' }
OPProjectController >> removeModel: aModel [

	(controllers select: [ :any | any model = aModel ]) do: [ :each | 
		self removeDiagramController: each ].
	project removeModel: aModel
]

{ #category : 'saving' }
OPProjectController >> replaceWritableProjectFile [

	^ self project storageFile: ((StSaveFilePresenter new
			    title: 'Set a file for saving an OpenPonk project';
			    extensions: #( opp ) named: 'OP projects';
			    openModal;
			    selectedEntry) ifNil: [ OPProjectSaveCanceledException signal ])
]

{ #category : 'saving' }
OPProjectController >> saveProject [

	| file |
	file := [ self writableProjectFile ]
		        on: OPProjectSaveCanceledException
		        do: [ ^ self inform: 'Saving canceled' ].
	self project saveInImage.
	self saveProjectTo: file.
	UIManager default
		inform: (String streamContents: [ :s |
				 s << 'Project saved to ' << file pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open the directory' ])
		actionOnClick: [ file openInOSFileBrowser ]
]

{ #category : 'saving' }
OPProjectController >> saveProjectAs [
	[ self replaceWritableProjectFile ]
		on: OPProjectSaveCanceledException
		do: [ ^ self inform: 'Saving canceled' ].
	self saveProject
]

{ #category : 'saving' }
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
	OPZipPersistence new save: store to: aFile.
	workbench updateTitle
]

{ #category : 'saving' }
OPProjectController >> saveState: saveData to: aFile [
	aFile
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (STON toJsonStringPretty: saveData) ]
]

{ #category : 'diagram selecting' }
OPProjectController >> selectInDiagram: aModelElement [

	controllers do: [ :dctrl | 
		dctrl controllers do: [ :ctrl | 
			ctrl model = aModelElement ifTrue: [ 
				| palette |
				palette := dctrl editor palette.
				palette selectSelectionTool selectedTool 
					selectedTargetControllers: { ctrl }.
				dctrl editor canvasPresenter roassalView canvas camera 
					translateTo: ctrl roassalShape position.
				^ self ] ] ]
]

{ #category : 'accessing' }
OPProjectController >> spApplication [

	^ workbench application
]

{ #category : 'opening' }
OPProjectController >> updateDiagram: aDiagram [

	| focusedController |
	focusedController := workbench focusedEditor ifNotNil: [ :editor |
		                     editor diagramController ].
	controllers
		detect: [ :ctrl | ctrl diagramElement = aDiagram ]
		ifFound: [ :ctrl |
			ctrl validate.
			aDiagram isOpen: true.
			aDiagram isRendered ifTrue: [ aDiagram updateFromRender ].
			aDiagram isSelected: ctrl = focusedController ]
		ifNone: [
			aDiagram
				isOpen: false;
				isSelected: false ]
]

{ #category : 'opening' }
OPProjectController >> updateDiagrams [

	self project diagrams do: [ :eachDiagram | 
		self updateDiagram: eachDiagram ]
]

{ #category : 'accessing' }
OPProjectController >> workbench: aWorkbench [
	workbench := aWorkbench 
]

{ #category : 'saving' }
OPProjectController >> writableProjectFile [
	[ self canProjectBeSavedToFile: self project storageFile ]
		whileFalse: [ self project storageFile
				ifNotNil: [ self
						inform: 'Unable to write to file ' , self project storageFile pathString ].
			self replaceWritableProjectFile ].
	^ self project storageFile
]
