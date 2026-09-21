Class {
	#name : 'OPRemoveRootModelCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'packageModel',
		'diagram',
		'projectController',
		'announcedEvents'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRemoveRootModelCommandTest >> setUp [
	super setUp.
	announcedEvents := OrderedCollection new.
	project := OPProject new.
	packageModel := OPTestContainerModel new.
	project addModel: packageModel.
	diagram := (OPOpenPonkDiagram forModelElement: packageModel) name: 'RootDiagram'.
	project addDiagram: diagram.
	projectController := project controllerClass new
		project: project;
		yourself.
	project announcer
		when: Announcement
		do: [ :anAnnouncement261 | announcedEvents add: anAnnouncement261 ]
		for: self
]

{ #category : 'running' }
OPRemoveRootModelCommandTest >> tearDown [
	project announcer unsubscribe: self.
	super tearDown
]

{ #category : 'tests' }
OPRemoveRootModelCommandTest >> testExecuteRemovesModelAndAssociatedDiagramAndAnnounces [
	| removeCommand announcedClasses |
	removeCommand := OPRemoveModelElementCommand
		model: packageModel
		projectController: projectController.

	removeCommand execute.

	self deny: (project hasModel: packageModel).
	self deny: (project diagrams includes: diagram).

	announcedClasses := announcedEvents collect: #class.
	self assertCollection: announcedClasses includesAll: {
		OPModelRemoved .
		OPDiagramRemoved }
]

{ #category : 'tests' }
OPRemoveRootModelCommandTest >> testRedoReappliesRemovalAndAnnounces [
	| removeCommand announcedClasses |
	removeCommand := OPRemoveModelElementCommand
		model: packageModel
		projectController: projectController.

	removeCommand execute.
	removeCommand undo.
	announcedEvents removeAll.
	removeCommand redo.

	self deny: (project hasModel: packageModel).
	self deny: (project diagrams includes: diagram).

	announcedClasses := announcedEvents collect: #class.
	self assertCollection: announcedClasses includesAll: {
		OPModelRemoved .
		OPDiagramRemoved }
]

{ #category : 'tests' }
OPRemoveRootModelCommandTest >> testUndoRestoresModelAndAssociatedDiagramAndAnnounces [
	| removeCommand announcedClasses |
	removeCommand := OPRemoveModelElementCommand
		model: packageModel
		projectController: projectController.

	removeCommand execute.
	announcedEvents removeAll.
	removeCommand undo.

	self assert: (project hasModel: packageModel).
	self assert: (project diagrams includes: diagram).

	announcedClasses := announcedEvents collect: #class.
	self assertCollection: announcedClasses includesAll: {
		OPModelAdded .
		OPDiagramAdded }
]
