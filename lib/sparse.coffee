# later = (func) ->
# 	(index) -> func(index)

module.exports = (length = 0, prefill, lazy = false) ->
	sparse = []
	for index in [0...length]
		closure = (pf, i) ->
			Object.defineProperty sparse, i, 
				get: -> if pf and pf.call then pf(i) else pf
		closure(prefill, index)
	sparse