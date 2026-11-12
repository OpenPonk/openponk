Extension { #name : 'OPPluginRegistry' }

{ #category : '*OpenPonk-Core-Tests' }
OPPluginRegistry class >> setDefaultForTesting [

	<script>
	^ self setDefault: (self new
			   add: OPTestPlugin new;
			   yourself)
]
