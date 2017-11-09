destruction
removeOwnedControllers
	(self allOwnedElementsInModel: self model)
		do: [ :each | 
			self diagramController controllers
				detect: [ :ctrl | ctrl model = each ]
				ifFound: #removeController ]