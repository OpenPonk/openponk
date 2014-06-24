accessing
buildVertex: aVertex
	self writer
		tag: 'element'
		with: [ 
			writer tag: 'type' with: (self vertexElementType: aVertex model).
			self writeVertexCoordinates: aVertex.
			writer tag: 'panel_attributes' with: (self umletConverter convertVertex: aVertex model).
			writer tag: 'additional_attributes.' ]