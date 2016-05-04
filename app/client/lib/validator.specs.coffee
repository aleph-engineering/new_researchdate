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

        it "returns false if given value: 'NONE'", ->
            valid = validator.validArgsForTimestamp 'NONE'
            expect(valid).to.be.false

        it "returns true if given other value than: 'NONE'", ->
            valid = validator.validArgsForTimestamp 'other'
            expect(valid).to.be.true


    describe 'validArgsForVerification method', ->
        it 'is defined', ->
            expect(validator.validArgsForVerification).not.to.be.undefined

        it 'returns false, if not given a TSR file', ->
            result = validator.validArgsForVerification null, {length: 10}
            expect(result).to.be.false

        it 'returns false, if given an empty TSR file', ->
            result = validator.validArgsForVerification {length: 0}, {length: 10}
            expect(result).to.be.false

        it 'returns false, if not given the original file', ->
            result = validator.validArgsForVerification {length: 10}, null
            expect(result).to.be.false

        it 'returns false, if given an empty original file', ->
            result = validator.validArgsForVerification {length: 10}, {length: 0}
            expect(result).to.be.false

        it 'returns true, if given two not empty files', ->
            result = validator.validArgsForVerification {length: 10}, {length: 10}
            expect(result).to.be.true


    describe 'fileExist method', ->
        it 'is defined', ->
            expect(validator.fileExist).not.to.be.undefined

        it 'returns false, if not given a file', ->
            result = validator.fileExist null
            expect(result).to.be.false

        it 'returns false, if given an empty file', ->
            result = validator.fileExist length: 0
            expect(result).to.be.false

        it 'returns true, if given a not empty file', ->
            result = validator.fileExist length: 10
            expect(result).to.be.true

    describe 'fileIsValid method', ->
        it 'is defined', ->
            expect(validator.fileIsValid).not.to.be.undefined

        it 'returns true, if file.size <= 266454270', ->
            result = validator.fileIsValid size: 266454270
            expect(result).to.be.true

        it 'returns false, if file.size >= 266454270', ->
            result = validator.fileIsValid size: 266454272
            expect(result).to.be.false
