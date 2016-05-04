validArgsForTimestamp = (file)->
    file? && file isnt 'NONE'

validArgsForVerification = (tsr, original)->
    tsr?.length > 0 and original?.length > 0

fileExist = (file) ->
    file?.length > 0

fileIsValid = (file) ->
    file?.size <= 266454270

exports.validArgsForTimestamp = validArgsForTimestamp
exports.validArgsForVerification = validArgsForVerification
exports.fileExist = fileExist
exports.fileIsValid = fileIsValid
