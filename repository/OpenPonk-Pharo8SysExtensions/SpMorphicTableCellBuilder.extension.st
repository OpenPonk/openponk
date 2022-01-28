Extension { #name : #SpMorphicTableCellBuilder }

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
SpMorphicTableCellBuilder >> visitLinkColumn: aTableColumn [
	| presenter morph |
	
	presenter := SpLinkPresenter new
		addStyle: 'table';
		label: (aTableColumn readObject: self item);
		yourself.
	
	aTableColumn url 
		ifNotNil: [ presenter url: (aTableColumn url value: self item) ].
	aTableColumn action 
		ifNotNil: [ presenter action: [ aTableColumn action value: self item ] ].

	morph := presenter buildWithSpec.
	presenter adapter applyStyle: morph.

	self 
		addCellMorph: morph
		column: aTableColumn
]
