JSZip = require 'jszip'
StreamToBuffer = require 'stream-to-buffer'
FileReaderStream = require 'filereader-stream'


class ZipReader

    constructor: () ->
        @zip = new JSZip()

    load: (file) ->
#        Returns a promise
        fileStream = FileReaderStream file
        zip = @zip
        return new Promise(
            (resolve, reject) ->
                StreamToBuffer fileStream, (error, fileBuffer) ->
                    unless error
                        zip.loadAsync(fileBuffer).then((loadedZip) ->
                            files = []
                            loadedZip.forEach (relativePath, file) ->
                                if not file.dir
                                    filename = file.name
                                    files.push filename
                            resolve files
                        ).catch((error) ->
                            reject error
                        )
                    else
                        reject error
        )

    getFile: (filename, asStream) ->
#        Returns a promise of the file
        useStreams = asStream or false
        if useStreams
            @zip.file(filename).nodeStream()
        else
            @zip.file(filename).async('nodebuffer')


exports.ZipReader = ZipReader
