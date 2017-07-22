*OpenPonk-Spec
openOnModel: aModel
	| project |
	project := self new.
	project name: aModel name.
	project addModel: aModel.
	project open