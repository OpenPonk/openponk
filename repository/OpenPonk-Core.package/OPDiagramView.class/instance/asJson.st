serializing
asJson
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				for: OPDiagramView
					do: [ :mapping | 
					mapping
						mapInstVars: mapping identifier instVarNames \ #(project model modelName modelType modelVersion filters).
					#(modelName modelVersion modelType) do: [ :each | mapping mapAccessor: each ].
					(mapping mapInstVar: #filters) valueSchema: #ListOfFilters ];
				for: #ListOfFilters customDo: [ :mapping | mapping listOfElementSchema: #Filter ];
				for: #Filter customDo: [ :mapping | mapping encoder: #encode ];
				mapInstVarsFor: OPDiagramViewCamera;
				mapInstVarsFor: Point;
				nextPut: self ]