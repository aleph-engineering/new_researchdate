getHashFromResponse = (response) ->
    hash = null
    if responseAndResponseStatus response
        hash = fillHashBufferAndConvert response
    return hash

responseStatusIsGranted = (response) ->
    response.status.status is 'granted'

responseStatusIsGrantedWithMods = (response) ->
    response.status.status is 'grantedWithMods'

fillHashBufferAndConvert = (response) ->
    timeStampTokenContent = response.timeStampToken.content
    eContent = timeStampTokenContent.encapContentInfo.eContent
    hashBuffer = new Buffer(eContent.messageImprint.hashedMessage)
    hashBuffer.toString 'hex'

responseAndResponseStatus = (response) ->
    responseStatus = (responseStatusIsGranted response || responseStatusIsGrantedWithMods response)
    response && responseStatus


tsr = exports

tsr.getHashFromResponse = getHashFromResponse
