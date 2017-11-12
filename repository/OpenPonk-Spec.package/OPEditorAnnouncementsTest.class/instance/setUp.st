initialization
setUp
	workbench := OPWorkbench new.
	announcer := workbench announcer.
	plugin := Mock new.
	plugin stub diagramControllerClass willReturn: OPTestDiagramController.
	workbench openProject: OPProject new.
	(workbench pluginRegistry stub pluginFor: Any) willReturn: plugin