"
Coordinator for an OPProject. Handles project-level lifecycle operations including saving, loading, merging, undo/redo coordination, and active diagram controllers.
"
Class {
	#name : 'OPProjectController',
	#superclass : 'Object',
	#instVars : [
		'workbench',
		'project',
		'controllers',
		'persistenceManager',
		'viewModelRegistry',
		'undoManager'
	],
	#classVars : [
		'RecentProjects'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'instance creation' }
OPProjectController class >> forProject: aProject [
	^ self new
		project: aProject;
		yourself
]

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
OPProjectController class >> openFromFile [

	self fromFileDo: [ :project | project open ]
]

{ #category : 'managing' }
OPProjectController >> addDiagramController: aDiagramController [
	(controllers includes: aDiagramController) ifTrue: [ ^ self ].
	controllers add: aDiagramController.
	aDiagramController projectController: self
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

{ #category : 'undo-redo' }
OPProjectController >> canRedo [
	"Answer whether an action can be redone in the project."
	^ self undoManager canRedo
]

{ #category : 'undo-redo' }
OPProjectController >> canUndo [
	"Answer whether an action can be undone in the project."
	^ self undoManager canUndo
]

{ #category : 'accessing' }
OPProjectController >> controllers [
	^ controllers
]

{ #category : 'saving' }
OPProjectController >> defaultProjectFileName [
	| baseName |
	baseName := self project
		ifNotNil: [ :currentProject |
			currentProject name ifNotNil: [ :projectName | projectName trimBoth ] ]
		ifNil: [ nil ].
	(baseName isNil or: [ baseName isEmpty ]) ifTrue: [ baseName := 'project' ].
	^ (FileNameSanitizer sanitize: baseName) , '.opp'
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
	controllers := OrderedCollection new.
	undoManager := OPUndoManager new
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
OPProjectController >> mergeModelsAndDiagramsByPlugin [
	| activePluginRegistry modelsByPlugin mergeableGroups |
	activePluginRegistry := workbench
		ifNotNil: [ :activeWorkbench | activeWorkbench pluginRegistry ]
		ifNil: [ OPPluginRegistry default ].
	modelsByPlugin := self project models groupedBy: [ :eachModel |
		activePluginRegistry pluginFor: eachModel ].
	mergeableGroups := modelsByPlugin associations select: [ :assoc |
		| groupModels groupDiagrams |
		groupModels := assoc value.
		groupDiagrams := groupModels flatCollect: [ :eachModel | self project diagramsOf: eachModel ].
		(groupModels size > 1 and: [ assoc key supportsMergingModels ])
			or: [ groupModels size = 1 and: [ groupDiagrams size > 1 ] ] ].
	mergeableGroups ifEmpty: [ ^ self ].
	self undoManager clear.
	mergeableGroups do: [ :assoc |
		| plugin groupModels groupDiagrams mergedOwnedElements seenModelElements mergedModel diagram |
		plugin := assoc key.
		groupModels := assoc value asArray.
		groupDiagrams := (groupModels flatCollect: [ :eachModel |
			self project diagramsOf: eachModel ]) asOrderedCollection.
		groupDiagrams do: [ :eachDiagram |
			self updateDiagram: eachDiagram.
			workbench ifNotNil: [ :activeWorkbench |
				activeWorkbench closeEditorOfDiagram: eachDiagram ] ].
		mergedOwnedElements := OrderedCollection new.
		seenModelElements := IdentitySet new.
		groupDiagrams do: [ :eachDiagram |
			eachDiagram ownedElements copy do: [ :eachOwnedElement |
				| modelElem |
				eachOwnedElement removeRender.
				modelElem := eachOwnedElement ownModelElement.
				(eachOwnedElement isDiagramOnly or: [
					modelElem isNil or: [ (seenModelElements includes: modelElem) not ] ])
					ifTrue: [
						modelElem ifNotNil: [ seenModelElements add: modelElem ].
						mergedOwnedElements add: eachOwnedElement ] ] ].
		mergedModel := groupModels size > 1
			ifTrue: [ plugin mergeModels: groupModels ]
			ifFalse: [ groupModels first ].
		groupModels do: [ :eachModel | self removeModel: eachModel ].
		viewModelRegistry ifNotNil: [ :registry |
			mergedModel ifNotNil: [
				(registry viewModelFor: mergedModel) allChildren do: [ :eachVM |
					eachVM instVarNamed: #parentViewModel put: nil ] ] ].
		diagram := OPOpenPonkDiagram forModelElement: mergedModel.
		diagram ownedElements: mergedOwnedElements.
		self project addDiagram: diagram.
		self project announcer announce: (OPModelAdded model: mergedModel).
		self project announcer announce: (OPDiagramAdded diagram: diagram).
		workbench ifNotNil: [
			| layouter |
			layouter := (self openEditorOnDiagram: diagram) diagramController layouter.
			layouter dominanceTreeLayout ] ]
]

{ #category : 'merging' }
OPProjectController >> mergeModelsAndDiagramsIntoOne [
	| showError models activePluginRegistry modelsByPlugin mergeableGroups dialogTitle |
	showError := [ :text |
		^ (GrowlMorph label: 'Unable to merge models' contents: text)
			backgroundColor: GrowlMorph theme dangerBackgroundColor;
			labelColor: GrowlMorph theme textColor;
			textColor: GrowlMorph theme textColorForNonStandardBackground;
			openInWorld ].
	models := self project models.
	models ifEmpty: [ ^ showError value: 'There are no models' ].
	activePluginRegistry := workbench
		ifNotNil: [ :activeWorkbench | activeWorkbench pluginRegistry ]
		ifNil: [ OPPluginRegistry default ].
	modelsByPlugin := models groupedBy: [ :each | activePluginRegistry pluginFor: each ].
	mergeableGroups := modelsByPlugin associations select: [ :assoc |
		| groupModels groupDiagrams |
		groupModels := assoc value.
		groupDiagrams := groupModels flatCollect: [ :eachModel | self project diagramsOf: eachModel ].
		groupModels size > 1 or: [ groupDiagrams size > 1 ] ].
	mergeableGroups ifEmpty: [
		modelsByPlugin size > 1 ifTrue: [
			^ showError value: 'Models of different types/metamodels cannot be merged together - there have to be at least 2 models or 2 diagrams of the same type' ].
		^ showError value: 'The model is as merged as it can be - there have to be at least 2 models or 2 diagrams' ].
	(mergeableGroups anySatisfy: [ :assoc |
		assoc value size > 1 and: [ assoc key supportsMergingModels not ] ])
		ifTrue: [ ^ showError value: 'Plugin of these models does not support merging' ].
	dialogTitle := modelsByPlugin size > 1
		ifTrue: [ 'Merge models and diagrams of each type?' ]
		ifFalse: [ 'Merge all models and diagrams into one?' ].
	SpConfirmDialog new
		title: dialogTitle;
		message: 'This is irreversible and original models and diagrams will be lost.';
		acceptLabel: 'Yes, merge them';
		cancelLabel: 'Cancel';
		onAccept: [ self mergeModelsAndDiagramsByPlugin ];
		openDialog
]

{ #category : 'merging' }
OPProjectController >> mergeWith: aProject [
	| otherProjectModels otherProjectDiagrams |
	otherProjectModels := aProject models copy.
	otherProjectDiagrams := aProject diagrams copy.
	project mergeWith: aProject.
	otherProjectModels do: [ :eachModel |
		project announcer announce: (OPModelAdded model: eachModel) ].
	otherProjectDiagrams do: [ :eachDiagram |
		project announcer announce: (OPDiagramAdded diagram: eachDiagram).
		workbench ifNotNil: [ self openEditorOnDiagram: eachDiagram ] ]
]

{ #category : 'saving' }
OPProjectController >> modelMementoFor: aModel [

	^ OPMemento model: aModel diagrams: (project diagramsOf: aModel)
]

{ #category : 'saving' }
OPProjectController >> modelMementos [
	^ self project models collect: [ :each | self modelMementoFor: each ]
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
	selected ifNotNil: [ workbench focusEditorOf: selected ].
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
OPProjectController >> recentProjects [
	^ RecentProjects ifNil: [ RecentProjects := OrderedDictionary new ]
]

{ #category : 'undo-redo' }
OPProjectController >> redo [
	"Redo the latest undone action in the active project."
	self undoManager redo
]

{ #category : 'removing' }
OPProjectController >> removeDiagram: aDiagram [

	project removeDiagram: aDiagram.
	self removeDiagramController: (controllers
			 detect: [ :any | any diagramElement = aDiagram ]
			 ifNone: [ ^ self ])
]

{ #category : 'managing' }
OPProjectController >> removeDiagramController: aDiagramController [
	controllers remove: aDiagramController ifAbsent: [ ].
	(aDiagramController respondsTo: #projectController:) ifTrue: [
		aDiagramController projectController: nil ]
]

{ #category : 'adding / removing' }
OPProjectController >> removeModel: aModel [
	| removedDiagrams |
	removedDiagrams := (project diagramsOf: aModel) copy.
	(controllers select: [ :any | any model = aModel ]) do: [ :each |
		self removeDiagramController: each ].
	project removeModel: aModel.
	viewModelRegistry ifNotNil: [ :registry |
		registry removeViewModelFor: aModel ].
	removedDiagrams do: [ :eachDiagram |
		project announcer announce: (OPDiagramRemoved diagram: eachDiagram) ].
	project announcer announce: (OPModelRemoved model: aModel)
]

{ #category : 'diagrams' }
OPProjectController >> renameDiagram: aDiagram to: aNewName [
	self undoManager execute: (OPRenameDiagramCommand
		diagram: aDiagram
		newName: aNewName
		project: self project)
]

{ #category : 'actions' }
OPProjectController >> renameProjectTo: aNewName [
	aNewName = self project name ifTrue: [ ^ self ].
	self undoManager execute: (OPRenameProjectCommand
		project: self project
		newName: aNewName)
]

{ #category : 'saving' }
OPProjectController >> replaceWritableProjectFile [
	| dialog |
	dialog := StSaveFilePresenter new
		title: 'Set a file for saving an OpenPonk project';
		extensions: #( opp ) named: 'OP projects';
		nameText: self defaultProjectFileName;
		yourself.
	self project storageFile ifNotNil: [ :file |
		file parent ifNotNil: [ :parent |
			parent exists ifTrue: [ dialog defaultFolder: parent ] ] ].
	dialog openModal.
	(dialog cancelled or: [ dialog selectedEntry isNil ])
		ifTrue: [ OPProjectSaveCanceledException signal ].
	^ self project storageFile: dialog selectedEntry
]

{ #category : 'saving' }
OPProjectController >> saveProject [

	| file message |
	file := [ self writableProjectFile ]
		        on: OPProjectSaveCanceledException
		        do: [ ^ InformativeNotification signal: 'Saving canceled' ].
	self project saveInImage.
	self saveProjectTo: file.
	message := String streamContents: [ :s |
			           s << 'Project saved to ' << file pathString.
			           s
				           cr;
				           cr.
			           s << 'Click to open the directory' ].
	(ProvideAnswerNotification signal: message) ifNil: [
			(GrowlMorph openWithLabel: 'Information' translated contents: message)
				vanishDelay: 5 seconds;
				actionBlock: [ file openInOSFileBrowser ] ]
]

{ #category : 'saving' }
OPProjectController >> saveProjectAs [

	[ self replaceWritableProjectFile ]
		on: OPProjectSaveCanceledException
		do: [ ^ InformativeNotification signal: 'Saving canceled' ].
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
	workbench ifNotNil: [ :activeWorkbench | activeWorkbench updateTitle ]
]

{ #category : 'selection' }
OPProjectController >> selectInDiagram: aModelElement [
	controllers do: [ :eachDiagramController |
		eachDiagramController controllers do: [ :eachController |
			eachController model = aModelElement ifTrue: [
				eachDiagramController selectController: eachController.
				eachDiagramController canvas camera
					translateTo: eachController roassalShape position.
				^ self ] ] ]
]

{ #category : 'accessing' }
OPProjectController >> spApplication [

	^ workbench application
]

{ #category : 'undo-redo' }
OPProjectController >> undo [
	"Undo the latest action in the active project."
	self undoManager undo
]

{ #category : 'undo-redo' }
OPProjectController >> undoManager [
	"Answer the undo manager associated with this project controller."
	^ undoManager ifNil: [ undoManager := OPUndoManager new ]
]

{ #category : 'updating' }
OPProjectController >> updateDiagram: aDiagram [
	| focusedController |
	focusedController := workbench ifNotNil: [ :activeWorkbench |
		activeWorkbench focusedEditor ifNotNil: [ :editor |
			editor diagramController ] ].
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
OPProjectController >> viewModel [

	^ self viewModelRegistry projectViewModel
]

{ #category : 'accessing' }
OPProjectController >> viewModelRegistry [
	^ viewModelRegistry ifNil: [
		viewModelRegistry := OPViewModelRegistry forProject: self project ]
]

{ #category : 'accessing' }
OPProjectController >> workbench: aWorkbench [
	workbench := aWorkbench 
]

{ #category : 'saving' }
OPProjectController >> writableProjectFile [
	[ self canProjectBeSavedToFile: self project storageFile ]
		whileFalse: [ self project storageFile
				ifNotNil: [ InformativeNotification signal: 'Unable to write to file ' , self project storageFile pathString ].
			self replaceWritableProjectFile ].
	^ self project storageFile
]
