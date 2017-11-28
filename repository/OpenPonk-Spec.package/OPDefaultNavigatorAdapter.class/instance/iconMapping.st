widget API
iconMapping
	^ {OPDiagram -> OPIcons current dcFsmDiagramIcon.
	OPNamedElement -> OPIcons current dcFsmRegularStateIcon.
	OPEdge -> OPIcons current dcFsmTransitionIcon.
	OPProject -> OPIcons current openponkIcon.
	Object -> #blank asIcon}