grammar
operation
	^ super operation
		==> [ :nodes | 
			Method new
				name: nodes second;
				parameters: nodes fourth;
				returnDataType: nodes sixth ]