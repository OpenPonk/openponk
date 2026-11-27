Extension { #name : 'SpMorphicTableCellBuilder' }

{ #category : '*OpenPonk-Spec' }
SpMorphicTableCellBuilder >> visitTriStateCheckboxColumn: aTableColumn [

	| state formSet buttonMorph containerMorph |
	state := aTableColumn readObject: self item.
	formSet := Smalltalk ui icons iconFormSetNamed: (aTableColumn iconNameForState: state).
	buttonMorph := ThreePhaseButtonMorph new
		               onFormSet: formSet;
		               offFormSet: formSet;
		               pressedFormSet: formSet;
		               target: aTableColumn;
		               actionSelector: #handleClickFor:state:;
		               arguments: {
				               self item.
				               state };
		               yourself.
	containerMorph := Morph new
		                  color: Color transparent;
		                  layoutPolicy: TableLayout new;
		                  listCentering: #center;
		                  wrapCentering: #center;
		                  vResizing: #spaceFill;
		                  extent: buttonMorph extent;
		                  addMorphBack: buttonMorph;
		                  yourself.
	self addCellMorph: containerMorph column: aTableColumn
]
