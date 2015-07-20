private
computePath
	canvas ifNil: [ ^ self ].
	path := self athensCanvas
		createPath: [ :builder | 
			builder absolute.
			self ccwCirclePath: builder radius: 0.5.
			self cwCirclePath: builder radius: 0.48.
			self ccwCirclePath: builder radius: 0.4 ]