JSZip = require 'jszip'
FileReaderStream = require 'filereader-stream'


class ZipGenerator

    constructor: () ->
        @zip = new JSZip()

    addFile: (file) =>
        zipStream = FileReaderStream file
        @zip.file file.name, zipStream

    addBuffer: (filename, buffer) =>
        @zip.file filename, buffer

    generate: () =>
#       Returns a promise
        @zip.generateAsync({
            type: "blob",
            streamFiles: true,
            comment: i18n 'timestamp.tsr_comment'
        })


exports.ZipGenerator = ZipGenerator
