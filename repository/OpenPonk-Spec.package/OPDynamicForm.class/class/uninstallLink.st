specs
uninstallLink
	self visitAst links ifNotNil: [ :links | links do: #uninstall ]