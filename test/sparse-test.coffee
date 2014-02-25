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

		describe 'callbacks', ->
			it 'should use callback with index for filler', ->
				sparse = new Sparse 1, (index) ->
					index + 'foo'
				(typeof sparse[0]).should.equal 'string'
				sparse[0].should.equal '0foo'

			it 'should default out of bounds to undefined', ->
				sparse = new Sparse 10, 7
				(typeof sparse[-1]).should.equal 'undefined'
				sparse[0].should.equal 7
				sparse[9].should.equal 7
				(typeof sparse[10]).should.equal 'undefined'

			had = {}
			it 'should optionally lazily prefill', ->
				cb = (i) ->
					had[i] = true
					i*2
				sparse = new Sparse 10, cb, lazy = true
				(typeof had[4]).should.equal 'undefined'
				sparse[4]
				had[4].should.equal true
				(typeof sparse[4]).should.equal 'number'
				sparse[4].should.equal 8

			it 'should not brake if lazy and non callback', ->
				sparse = new Sparse 10, 5, lazy = true
				sparse[2].should.equal 5