initialization
newDiagramSubmenu
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
							item
								name: 'Finite State Machine Diagram';
								icon: (self iconForDiagram: #DCFsm);
								action: [ 
											self projectController project
												addDiagram:
													(DCFsm new
														name: 'FSM Diagram';
														yourself) ] ];
				addItem: [ :item | 
							item
								name: 'OntoUML Diagram';
								icon: (self iconForDiagram: #DCOmlDiagram);
								action: [ 
											self projectController project
												addDiagram:
													(DCOmlDiagram new
														name: 'OntoUML Diagram';
														yourself) ] ].
			(Smalltalk globals includesKey: #DMMindMap)
				ifTrue: [ 
					group
						addItem: [ :item | 
							item
								name: 'MindMap';
								icon: (self iconForDiagram: #DMMindMap);
								action: [ 
											self projectController project
												addDiagram:
													(#DMMindMap asClass new
														name: 'New MindMap';
														yourself) ] ] ].
			(Smalltalk globals includesKey: #BormDiagram)
				ifTrue: [ 
					group
						addItem: [ :item | 
							item
								name: 'BORM OR Diagram';
								icon: (self iconForDiagram: #BormDiagram);
								action: [ 
											self projectController project
												addDiagram:
													(#BormDiagram asClass new
														name: 'BORM Diagram';
														yourself) ] ] ] ]