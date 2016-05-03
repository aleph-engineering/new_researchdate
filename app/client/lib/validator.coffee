validArgsForTimestamp = (file) ->
    file is 'NONE'

validArgsForVerification = (tsr, original) ->
    tsr.length > 0 and original.length > 0

fileExist = (file) ->
    file.length > 0

exports.validArgsForTimestamp = validArgsForTimestamp
exports.validArgsForVerification = validArgsForVerification
exports.fileExist = fileExist
