initialization
initializeCanvasMenu
	menuModel
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: '-';
						description: 'Zoom out';
						action: [ self canvasModel zoom: self canvasModel zoom * 0.8 ] ].
			group
				addItem: [ :item | 
					item
						name: 'Zoom to 100%';
						description: 'Zoom to 100%';
						action: [ self canvasModel zoom: 1.0001 ] ].
			group
				addItem: [ :item | 
					item
						name: '+';
						description: 'Zoom in';
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
						action: [ self showLayoutSubmenu ] ] ].
	menuModel applyTo: self