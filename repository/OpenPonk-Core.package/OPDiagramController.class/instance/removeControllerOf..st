deprecated
removeControllerOf: aModelElement
	self
		deprecated: 'Use #removeController: and #removeController instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self removeController: (self controllerForModel: aModelElement)