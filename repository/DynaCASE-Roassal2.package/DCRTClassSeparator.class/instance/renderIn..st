hooks
renderIn: aView
	self first view ifNil: [ self do: [ :each | aView add: each ] ]