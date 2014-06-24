accessing
buildTransition: aTransition
	self writer
		tag: 'element'
		with: [ 
			writer tag: 'type' with: (self transitionElementType).
			 ].
"

	self writer
		tag: 'element'
		with: [ 
			writer tag: 'type' with: (self elementTypeOf: aVertex model).
			self writeVertexCoordinates: aVertex.
			writer tag: 'panel_attributes' with: (self umletConverter convertVertex: aVertex model).
			writer tag: 'additional_attributes.' ]"