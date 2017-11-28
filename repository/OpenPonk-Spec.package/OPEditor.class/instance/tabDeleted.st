updating
tabDeleted
	self workbench projectController removeDiagramController: diagramController.
	self unregisterShortcutsOn: self workbench.
	diagramController removeAllControllers