hashesHelpers = require './hash_helpers'


describe 'HashHelpers module', ->
    it 'is defined', ->
        expect(hashesHelpers).to.not.be.undefined


    describe 'HASHES object', ->
        beforeEach ->
            @hashes = hashesHelpers.HASHES

        it 'is defined', ->
            expect(@hashes).to.not.be.undefined


        describe 'md2 hash algorithm description', ->
            beforeEach ->
                @md2 = @hashes.md2

            it 'is defined', ->
                expect(@md2).to.not.be.undefined

            it 'contains a property: "oid"', ->
                expect(@md2).to.have.property 'oid'

            it '"oid" has expected value', ->
                expect(@md2.oid).to.equal '1.2.840.113549.2.2'

            it 'contains a property: "der"', ->
                expect(@md2).to.have.property 'der'

            it '"der" has expected value', ->
                expected = [0x30, 0x20, 0x30, 0x0c, 0x06, 0x08, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x02, 0x05,
                    0x00, 0x04, 0x10]
                expect(@md2.der).to.eql expected


        describe 'md5 hash algorithm description', ->
            beforeEach ->
                @md5 = @hashes.md5

            it 'is defined', ->
                expect(@md5).to.not.be.undefined

            it 'contains a property: "oid"', ->
                expect(@md5).to.have.property 'oid'

            it '"oid" has expected value', ->
                expect(@md5.oid).to.equal '1.2.840.113549.2.5'

            it 'contains a property: "der"', ->
                expect(@md5).to.have.property 'der'

            it '"der" has expected value', ->
                expected = [0x30, 0x20, 0x30, 0x0c, 0x06, 0x08, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, 0x05,
                    0x00, 0x04, 0x10]
                expect(@md5.der).to.eql expected


        describe 'sha1 hash algorithm description', ->
            beforeEach ->
                @sha1 = @hashes.sha1

            it 'is defined', ->
                expect(@sha1).to.not.be.undefined

            it 'contains a property: "oid"', ->
                expect(@sha1).to.have.property 'oid'

            it '"oid" has expected value', ->
                expect(@sha1.oid).to.equal '1.3.14.3.2.26'

            it 'contains a property: "der"', ->
                expect(@sha1).to.have.property 'der'

            it '"der" has expected value', ->
                expected = [0x30, 0x21, 0x30, 0x09, 0x06, 0x05, 0x2b, 0x0e, 0x03, 0x02, 0x1a, 0x05, 0x00, 0x04, 0x14]
                expect(@sha1.der).to.eql expected


        describe 'sha256 hash algorithm description', ->
            beforeEach ->
                @sha256 = @hashes.sha256

            it 'is defined', ->
                expect(@sha256).to.not.be.undefined

            it 'contains a property: "oid"', ->
                expect(@sha256).to.have.property 'oid'

            it '"oid" has expected value', ->
                expect(@sha256.oid).to.equal '2.16.840.1.101.3.4.2.1'

            it 'contains a property: "der"', ->
                expect(@sha256).to.have.property 'der'

            it '"der" has expected value', ->
                expected = [0x30, 0x31, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
                    0x05, 0x00, 0x04, 0x20]
                expect(@sha256.der).to.eql expected


        describe 'sha384 hash algorithm description', ->
            beforeEach ->
                @sha384 = @hashes.sha384

            it 'is defined', ->
                expect(@sha384).to.not.be.undefined

            it 'contains a property: "oid"', ->
                expect(@sha384).to.have.property 'oid'

            it '"oid" has expected value', ->
                expect(@sha384.oid).to.equal '2.16.840.1.101.3.4.2.2'

            it 'contains a property: "der"', ->
                expect(@sha384).to.have.property 'der'

            it '"der" has expected value', ->
                expected = [0x30, 0x41, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
                    0x05, 0x00, 0x04, 0x30]
                expect(@sha384.der).to.eql expected


        describe 'sha512 hash algorithm description', ->
            beforeEach ->
                @sha512 = @hashes.sha512

            it 'is defined', ->
                expect(@sha512).to.not.be.undefined

            it 'contains a property: "oid"', ->
                expect(@sha512).to.have.property 'oid'

            it '"oid" has expected value', ->
                expect(@sha512.oid).to.equal '2.16.840.1.101.3.4.2.3'

            it 'contains a property: "der"', ->
                expect(@sha512).to.have.property 'der'

            it '"der" has expected value', ->
                expected = [0x30, 0x51, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
                    0x05, 0x00, 0x04, 0x40]
                expect(@sha512.der).to.eql expected
