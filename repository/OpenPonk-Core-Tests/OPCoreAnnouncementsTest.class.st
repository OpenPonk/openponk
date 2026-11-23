"
Verifies core diagram and model hierarchy announcement payloads and accessors.
"
Class {
	#name : 'OPCoreAnnouncementsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Announcements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Announcements'
}

{ #category : 'tests' }
OPCoreAnnouncementsTest >> testDiagramAddedStoresDiagram [

	| diagram announcement |
	diagram := OPOpenPonkDiagram new.
	announcement := OPDiagramAdded diagram: diagram.
	self assert: announcement diagram identicalTo: diagram
]

{ #category : 'tests' }
OPCoreAnnouncementsTest >> testDiagramRemovedStoresDiagram [

	| diagram announcement |
	diagram := OPOpenPonkDiagram new.
	announcement := OPDiagramRemoved diagram: diagram.
	self assert: announcement diagram identicalTo: diagram
]

{ #category : 'tests' }
OPCoreAnnouncementsTest >> testDiagramRenamedStoresDiagramOldAndNewName [

	| diagram announcement |
	diagram := OPOpenPonkDiagram new.
	announcement := OPDiagramRenamed diagram: diagram oldName: 'Before' newName: 'After'.
	self assert: announcement diagram identicalTo: diagram.
	self assert: announcement oldName equals: 'Before'.
	self assert: announcement newName equals: 'After'
]

{ #category : 'tests' }
OPCoreAnnouncementsTest >> testModelChildrenChangedEventsStoreModelAndChild [

	| container entity added removed |
	container := OPTestContainerModel new.
	entity := OPTestEntityModel new.
	added := OPModelChildAdded model: container child: entity.
	removed := OPModelChildRemoved model: container child: entity.
	self assert: added model identicalTo: container.
	self assert: added child identicalTo: entity.
	self assert: removed model identicalTo: container.
	self assert: removed child identicalTo: entity
]
