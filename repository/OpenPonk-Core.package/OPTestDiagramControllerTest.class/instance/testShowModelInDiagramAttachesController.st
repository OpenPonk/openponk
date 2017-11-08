tests - construction
testShowModelInDiagramAttachesController
	| entity |
	entity := OPTestEntityModel new.
	diagramController showModelInDiagram: entity.
	self shouldnt: (diagramController controllerForModel: entity) raise: NotFound