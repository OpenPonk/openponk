Extension { #name : #SpMorphicScrollableAdapter }

{ #category : #'*OpenPonk-Spec' }
SpMorphicScrollableAdapter >> childWidget [

	self flag:
		'Pharo 9 compatibility fix - should be replaced by original method in Pharo 10+'.
	^ self children
		  ifNotEmpty: [ :aCollection | aCollection first ]
		  ifEmpty: [ nil ]
]

{ #category : #'*OpenPonk-Spec' }
SpMorphicScrollableAdapter >> layout: aLayout [

	self flag:
		'Pharo 9 compatibility fix - should be replaced by original method in Pharo 10+'.

	layout := aLayout.

	emptyLayoutMarker := PanelMorph new
		                     hResizing: #spaceFill;
		                     vResizing: #spaceFill;
		                     yourself.
	widget ifNil: [ 
		widget := GeneralScrollPane new
			          changeScrollerTableLayout;
			          hResizing: #spaceFill;
			          vResizing: #spaceFill;
			          color: Color transparent;
			          borderColor: Color transparent;
			          scrollTarget: emptyLayoutMarker;
			          yourself ].

	aLayout whenChildrenAddedDo: [ :ann | 
		self
			basicAdd: ann child
			constraints: (aLayout constraintsFor: ann child)
			to: widget ].

	aLayout whenChildrenRemovedDo: [ :ann | self removeChild: ann child ].

	super layout: aLayout
]
