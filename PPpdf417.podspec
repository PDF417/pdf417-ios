Pod::Spec.new do |s|
  
  s.name        = "PPpdf417"
  s.version     = "5.0.5"
  s.summary     = "A delightful component for barcode scanning"
  s.homepage    = "http://pdf417.mobi"
  
  s.description = <<-DESC
        PDF417.mobi SDK is a delightful component for quick and easy scanning of PDF417, and many other types of 1D and 2D barcodes.
        The SDK offers:
        
                - world leading technology for scanning **PDF417 barcodes**
                - fast, accurate and robust scanning for all other barcode formats
                - integrated camera management
                - layered API, allowing everything from simple integration to complex UX customizations.
                - lightweight and no internet connection required
                - enteprise-level security standards
                - data parsing from **US Drivers licenses**
        DESC
                  
  s.screenshots = [ 
        "https://s2.mzstatic.com/us/r30/Purple4/v4/62/7f/68/627f688f-d786-820b-d507-33b488d5565a/screen322x572.jpeg",
        "https://s3.mzstatic.com/us/r30/Purple4/v4/10/40/ed/1040eddb-1b9f-dc0a-4499-2453e174173d/screen322x572.jpeg"
        ]
  
  s.license     = { 
        :type => 'commercial',
        :text => <<-LICENSE
                © 2013-2015 MicroBlink Ltd. All rights reserved.
                For full license text, visit http://pdf417.mobi/doc/PDF417license.pdf
                LICENSE
        }

  s.authors     = {
        "MicroBlink" => "info@microblink.com",
        "Jurica Cerovec" => "jurica.cerovec@microblink.com"
  }

  s.source      = { 
        :git => 'https://github.com/PDF417/pdf417-ios.git', 
        :tag => "v5.0.5"
  }

  s.platform     = :ios

  # ――― MULTI-PLATFORM VALUES ――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = '8.0.0'
  s.ios.resources = "MicroBlink.bundle"
  s.ios.requires_arc = false
  s.ios.vendored_frameworks = 'MicroBlink.framework'
  s.ios.frameworks = 'Accelerate', 'AVFoundation', 'AudioToolbox', 'AssetsLibrary', 'CoreMedia'
  s.ios.libraries = 'c++', 'iconv'

end
