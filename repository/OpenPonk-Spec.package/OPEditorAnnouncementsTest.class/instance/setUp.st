initialization
setUp
	plugin := Mock new.
	plugin stub diagramControllerClass willReturn: OPTestDiagramController.
	(plugin stub isPluginFor: Any) willReturn: true.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: plugin).
	project := OPProject new.
	project addModel: OPTestContainerModel new.
	project addModel: OPTestContainerModel new.
	workbench := OPWorkbench new.
	announcer := workbench announcer.
	workbench openProject: project