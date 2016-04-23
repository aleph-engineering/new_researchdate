startup = require './startup'


describe 'Lib Startup Module', ->
    it 'is defined', ->
        expect(startup).not.to.be.undefined


    describe 'setDefaultLanguage function', ->
        before ->
            @i18nSetDefaultLanguage = sinon.spy i18n, 'setDefaultLanguage'
            do startup.setDefaultLanguage

        after ->
            do @i18nSetDefaultLanguage.restore


        it 'sets default language to "en"', ->
            assert(
                @i18nSetDefaultLanguage.calledWithExactly 'en'
                'English language was not set as the default language'
            )
