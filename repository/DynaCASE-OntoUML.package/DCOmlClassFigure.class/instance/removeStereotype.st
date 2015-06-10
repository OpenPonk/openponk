private
removeStereotype
	stereotype ifNil: [ ^ self ].
	self remove: stereotype.
	stereotype := nil