widget API
iconMapping
	^ {OPDiagram -> OPIcons current dcFsmDiagramIcon.
	OPNamedElement -> OPIcons current dcFsmRegularStateIcon.
	OPEdge -> OPIcons current dcFsmTransitionIcon.
	Object -> OPIcons current dcFsmRegularStateIcon}