# later = (func) ->
# 	(index) -> func(index)

module.exports = (length = 0, prefill, lazy = false) ->
	sparse = ((if prefill and prefill.call and not lazy then prefill(i) else prefill) for i in [0...length])
	if lazy
		for index in [0...length]
			closure = (cb, i) ->
				Object.defineProperty sparse, i, get: -> cb(i)
			closure(prefill, index)
	sparse