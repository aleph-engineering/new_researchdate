validArgsForTimestamp = (file)->
    file? && file isnt 'NONE'

validArgsForVerification = (zip)->
    zip?

fileExist = (file) ->
    file?.length > 0

fileIsValid = (file) ->
    file?.size <= 545259520

dropzoneEmpty = (dropzone) ->
    dropzone.files.length is 0

dropzoneValid = (dropzone) ->
    dropzone.files.length is 1 and dropzone.files[0].status isnt 'error'

exports.validArgsForTimestamp = validArgsForTimestamp
exports.validArgsForVerification = validArgsForVerification
exports.fileExist = fileExist
exports.fileIsValid = fileIsValid
exports.dropzoneEmpty = dropzoneEmpty
exports.dropzoneValid = dropzoneValid
