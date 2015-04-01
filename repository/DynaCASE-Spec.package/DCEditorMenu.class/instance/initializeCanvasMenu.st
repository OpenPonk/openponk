initialization
initializeCanvasMenu
	menuModel
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						description: 'Zoom out';
						icon: Smalltalk ui icons dcZoomOutIcon;
						action: [ self canvasModel zoom: self canvasModel zoom * 0.8 ] ].
			group
				addItem: [ :item | 
					item
						name: '100%';
						description: 'Zoom to 100%';
						icon: Smalltalk ui icons dcZoomIcon;
						action: [ self canvasModel zoom: 1.0001 ] ].
			group
				addItem: [ :item | 
					item
						description: 'Zoom in';
						icon: Smalltalk ui icons dcZoomInIcon;
						action: [ self canvasModel zoom: self canvasModel zoom * 1.25 ] ].
			group
				addItem: [ :item | 
					item
						name: 'View All';
						description: 'Show whole diagram';
						action: [ self canvasModel showAllFigures ] ].
			group
				addItem: [ :item | 
					item
						name: 'Export as';
						description: 'Export diagram as';
						icon: Smalltalk ui icons smallExportIcon;
						action: [ self showExportFormatMenu ] ].
			group
				addItem: [ :item | 
					item
						name: 'Layout';
						description: 'Layout diagram';
						action: [ self showLayoutSubmenu ] ].
			group
				addItem: [ :item | 
					item
						name: 'Diagram Controller';
						description: 'Inspect Diagram Controller';
						action: [ self editor diagramController inspect ] ].
			group
				addItem: [ :item | 
					item
						name: 'Inspect View';
						description: 'Inspect View';
						action: [ self canvasModel roassalView inspect ] ] ].
	menuModel applyTo: self