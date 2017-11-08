deprecated
createController: aModel
	self
		deprecated: 'Use newControllerFor: instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self newControllerFor: aModel