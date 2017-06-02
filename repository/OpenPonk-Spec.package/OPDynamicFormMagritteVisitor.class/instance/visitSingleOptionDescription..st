visiting
visitSingleOptionDescription: aSingleOptionDescription
	(aSingleOptionDescription isExtensible
		ifTrue: [ form addEditableDroplist: aSingleOptionDescription label ]
		ifFalse: [ form addDroplist: aSingleOptionDescription label ])
		items: aSingleOptionDescription options;
		displayBlock: [ :each | aSingleOptionDescription labelForOption: each ];
		iconHolder: [ :each :item | aSingleOptionDescription iconForOption: each ];
		setSelectedItem: (aSingleOptionDescription accessor read: controller);
		whenSelectedItemChanged: [ :newValue | aSingleOptionDescription accessor write: newValue to: controller ]