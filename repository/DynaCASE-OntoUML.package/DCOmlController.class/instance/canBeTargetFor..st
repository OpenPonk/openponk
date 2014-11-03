testing
canBeTargetFor: aController
	^ acceptsAsTarget includes: aController class asString asSymbol