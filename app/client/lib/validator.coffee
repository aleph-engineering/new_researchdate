validArgsForTimestamp = (file)->
    file? && file isnt 'NONE'

validArgsForVerification = (zip)->
    zip?

fileExist = (file) ->
    file?.length > 0

fileIsValid = (file) ->
    file?.size <= 251658240

dropzoneEmpty = (dropzone) ->
    dropzone.files.length is 0

exports.validArgsForTimestamp = validArgsForTimestamp
exports.validArgsForVerification = validArgsForVerification
exports.fileExist = fileExist
exports.fileIsValid = fileIsValid
exports.dropzoneEmpty = dropzoneEmpty
