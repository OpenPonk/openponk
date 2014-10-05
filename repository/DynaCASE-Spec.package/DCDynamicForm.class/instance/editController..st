as yet unclassified
editController: aController
	aController
		ifNil: [ 
			components size > 0
				ifTrue: [ 
					self reset.
					self rebuildWidget ] ]
		ifNotNil: [ 
			self reset.
			aController buildEditorForm: self.
			self rebuildWidget ]