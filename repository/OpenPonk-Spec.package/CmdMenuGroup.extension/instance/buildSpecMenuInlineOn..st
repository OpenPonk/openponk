*OpenPonk-Spec
buildSpecMenuInlineOn: aGroup
	self contents do: [ :each | each buildSpecMenuOn: aGroup ]