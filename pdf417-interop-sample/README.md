About
=====

This is a sample IOS application that demonstrates how to interact with the **pdf4317** scanner application from your own application to request scanning and retrieve barcode data.

Integration
===========

To integrate your application you need to use the custom URL scheme recognized by the `pdf417` scanner.

> Most of the details explained here already get hadled by the utility code provided with the sample aplication. You are free to use this code in your own applications.

**Example**

    pdf417://scan?type=PDF417&beep=true&callback=myscheme://myaction

**Format of the url**

    pdf417://<action>?<parameters>

**Actons**

Supported actions by the url scheme

+ **scan** - the only supported action is to initiate a single barcode scan which opens the pdf417 application in camera mode, ready to recognise a barcode

**Parameters**

Supported parameters by the url scheme

+ **type** - list of barcode types you want the scanner to scan for, the supported are:
    + PDF417
    + QR Code
    + Code 128
    + Code 39
    + EAN 13
    + EAN 8
    + ITF
    + UPCA
    + UPCE
+ **callback** - an url which will be called by **pdf417** to return controll back to your application
+ **beep** - turns on or off the "beep" sound played when successfully scanning a barcode, can be set to `true` or `false` (default is `true`)

**Callback**

The format of the callback

    <callback>?data=<barcode_data>&type=<type>

+ **callback** - the url you gave **pdf417** via the `callback` parameter above
+ **barcode_data** - hex encoded data retrieved from the scanned barcode
+ **type** - the barcode type that was scanned