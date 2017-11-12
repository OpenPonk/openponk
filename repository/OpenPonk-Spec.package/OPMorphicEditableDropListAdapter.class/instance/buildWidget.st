factory
buildWidget
	^ OPSpecEditableDropListMorph new
		wrapSelector: #wrapItem:index:;
		on: self
			list: #getList
			selected: #getIndex
			changeSelected: #setIndex:;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		addToListSel: #addToList:;
		yourself