validArgsForTimestamp = (file)->
    file? && file isnt 'NONE'

validArgsForVerification = (zip)->
    zip?

fileExist = (file) ->
    file?.length > 0

fileIsValid = (file) ->
    file?.size <= 266454270

exports.validArgsForTimestamp = validArgsForTimestamp
exports.validArgsForVerification = validArgsForVerification
exports.fileExist = fileExist
exports.fileIsValid = fileIsValid
