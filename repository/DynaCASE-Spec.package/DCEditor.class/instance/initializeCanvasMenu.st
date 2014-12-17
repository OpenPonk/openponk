initialization
initializeCanvasMenu
	canvasMenuModel
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: '-';
						description: 'Zoom out';
						action: [ canvasModel zoom: canvasModel zoom * 0.8 ] ].
			group
				addItem: [ :item | 
					item
						name: '100%';
						description: 'Zoom to 100%';
						action: [ canvasModel zoom: 1.0001 ] ].
			group
				addItem: [ :item | 
					item
						name: '+';
						description: 'Zoom in';
						action: [ canvasModel zoom: canvasModel zoom * 1.25 ] ].
			group
				addItem: [ :item | 
					item
						name: 'View All';
						description: 'Show whole diagram';
						action: [ canvasModel showAllFigures ] ].
			group
				addItem: [ :item | 
					item
						name: 'Export as';
						description: 'Export diagram as';
						icon: Smalltalk ui icons smallExportIcon;
						action: [ self showExportFormatMenu ] ] ].
	canvasMenuModel applyTo: self