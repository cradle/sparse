# later = (func) ->
# 	(index) -> func(index)

module.exports = (length = 0, prefill) ->
	got = {}
	res = {}
	sparse = []
	for index in [0...length]
		closure = (pf, i) ->
			Object.defineProperty sparse, i, 
				get: ->
					unless got[i]
						res[i] = if pf and pf.call then pf(i) else pf
						got[i] = true
					res[i]
				set: (val) ->
					got[i] = true
					res[i] = val
		closure(prefill, index)
	sparse