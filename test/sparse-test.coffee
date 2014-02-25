require 'should'

lib = '../lib/sparse'

describe 'Sparse', ->
	it 'should be a function', ->
		Sparse = require lib
		(typeof Sparse).should.be.equal('function')

	describe 'instance', ->
		Sparse = null

		beforeEach ->
			Sparse = require lib

		it 'should default empty', ->
			sparse = new Sparse
			sparse.length.should.equal(0)

		it 'should be of length n', ->
			sparse = new Sparse 1
			sparse.length.should.equal(1)

		it 'should default prefill undefined', ->
			sparse = new Sparse 1
			(typeof sparse[0]).should.equal('undefined')

		it 'should optionally prefill', ->
			sparse = new Sparse 1, 'foo'
			sparse[0].should.equal 'foo'

		it 'should be settable', ->
			sparse = new Sparse 10
			sparse[5] = 'blah'
			sparse[5].should.equal 'blah'

		it 'should not fill past bounds', ->
			sparse = new Sparse 10, 'oob'
			(typeof sparse[15]).should.equal 'undefined'

		describe 'callbacks', ->
			it 'should use callback with index for filler', ->
				sparse = new Sparse 1, (index) ->
					index + 'foo'
				(typeof sparse[0]).should.equal 'string'
				sparse[0].should.equal '0foo'

			it 'should use callback with index for filler', ->
				sparse = new Sparse 10, (index) ->
					index + 'foo'
				sparse[5] = '5bar'
				sparse[5].should.equal '5bar'

			it 'should default out of bounds to undefined', ->
				sparse = new Sparse 10, 7
				(typeof sparse[-1]).should.equal 'undefined'
				sparse[0].should.equal 7
				sparse[9].should.equal 7
				(typeof sparse[10]).should.equal 'undefined'

			it 'should optionally lazily prefill', ->
				had = {}
				cb = (i) ->
					had[i] = true
					i*2
				sparse = new Sparse 10, cb
				(typeof had[4]).should.equal 'undefined'
				sparse[4]
				had[4].should.equal true
				(typeof sparse[4]).should.equal 'number'
				sparse[4].should.equal 8

			it 'should not brake if lazy and non callback', ->
				sparse = new Sparse 10, 5
				sparse[2].should.equal 5

			it 'should slice', ->
				sparse = new Sparse 1000, (i) -> i*i
				sparse[500].should.equal 250000
				sparse.slice(10,20)[0].should.equal 100

			describe 'push unshift', ->
				ids = sparse = null
				beforeEach ->
					ids = [5,10,100,151]
					sparse = new Sparse ids.length, (i) -> ids[i]

				it 'should map', ->
					sparse[2].should.equal 100

				it 'should not move when map is pushed', ->
					ids.push[191]
					sparse[3].should.equal 151

				it 'should allow push', ->
					sparse.push(69)
					sparse[4].should.equal 69

				it 'should not move when pushed', ->
					sparse.push(69)
					sparse[0].should.equal 5

				it 'should allow unshifted', ->
					sparse.unshift(191)
					sparse[0].should.equal 191

				it 'should move when unshifted', ->
					sparse.unshift(191)
					sparse[3].should.equal 5