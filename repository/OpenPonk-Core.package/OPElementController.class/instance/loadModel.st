deprecated
loadModel
	self deprecated: 'Method will be removed without replacement.'
"	self model ifNil: [ self model: self createModel ].
	^ self model"