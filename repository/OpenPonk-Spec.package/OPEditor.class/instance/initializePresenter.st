initialization
initializePresenter
	| menu |
	menu := OPDiagramToolbarActivation
		buildMenuInContext: (CmdSimpleToolContext for: canvasModel).
	menu buildSpecMenuOn: canvasMenuModel
	"canvasMenuModel
		addGroup: [ :group | 
			menu rootItems
				do: [ :cmdItem | 
					cmdItem isCommandItem
						ifTrue: [ group
								addItem: [ :item | 
									item
										name: cmdItem name;
										icon: cmdItem icon;
										action: [ cmdItem activator executeCommand ] ] ]
						ifFalse: [ cmdItem contents
								do: [ :cmd | 
									group
										addItem: [ :item | 
											item
												name: cmd name;
												icon: cmd icon;
												action: [ cmd activator executeCommand ] ] ] ] ] ]"