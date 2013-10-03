About
=====

This is a sample IOS application that demonstrates how to interact with the `pdf4317` scanner application from your own application to request scanning and retrieve barcode data.

Integration
===========

To integrate your application you need to use the custom URL scheme recognized by the `pdf417` scanner.

Example:

    pdf417://scan?result=json&callback=myscheme://myaction

Format of the url:

    pdf417://<action>?<parameters>

Actons:

    scan

Parameters:

    result - format of the result, can be "text" or "json"
    callback - an url which will be called by pdf417 to return controll back to your application and give you the results in the form of a "result=" parameter