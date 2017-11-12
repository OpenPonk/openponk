*OpenPonk-Spec
opUpdateOn: aController
	self
		propertyAt: #opUpdateBlock
		ifPresent: [ :block | block value: (self read: aController) ]