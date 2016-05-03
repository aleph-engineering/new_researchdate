validator = require './validator'


describe 'Validator module', ->
    it 'is defined', ->
        expect(validator).not.to.be.undefined

    describe 'validArgsForTimestamp method', ->
        it 'is defined', ->
            expect(validator.validArgsForTimestamp).not.to.be.undefined

        it "returns false if given undefined", ->
            valid = validator.validArgsForTimestamp undefined
            expect(valid).to.be.false

        it "returns false if given null", ->
            valid = validator.validArgsForTimestamp null
            expect(valid).to.be.false

        it "returns false if given other value than: 'NONE'", ->
            valid = validator.validArgsForTimestamp 'A'
            expect(valid).to.be.false

        it "returns true if given value: 'NONE'", ->
            valid = validator.validArgsForTimestamp 'NONE'
            expect(valid).to.be.true
