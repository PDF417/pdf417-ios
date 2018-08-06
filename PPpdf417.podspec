Pod::Spec.new do |s|
  
  s.name        = "PPpdf417"
  s.version     = "7.1.0"
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
        "http://a2.mzstatic.com/us/r1000/041/Purple6/v4/72/86/bd/7286bde4-911d-0561-4934-7e7fbb5d2033/mzl.zajzkcwv.320x480-75.jpg",
        "http://a4.mzstatic.com/us/r1000/010/Purple4/v4/a7/0f/90/a70f90ae-8c70-4709-9292-9ce0299fd712/mzl.jjhpudai.320x480-75.jpg",
        "http://a4.mzstatic.com/us/r1000/055/Purple6/v4/f1/ce/f5/f1cef57c-ad99-886a-f3b8-643428136ef7/mzl.mjottsci.320x480-75.jpg"
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
        "Jurica Cerovec" => "jurica.cerovec@microblink.com",
        "Jura Skrlec" => "jura.skrlec@microblink.com"
  }

  s.source      = { 
        :git => 'https://github.com/PDF417/pdf417-ios.git', 
        :tag => "v7.1.0"
  }

  s.platform     = :ios

  # ――― MULTI-PLATFORM VALUES ――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.ios.deployment_target = '8.0.0'
  s.ios.resources = "MicroBlink.bundle"
  s.ios.requires_arc = false
  s.ios.vendored_frameworks = 'MicroBlink.framework'
  s.ios.frameworks = 'Accelerate', 'AVFoundation', 'AudioToolbox', 'AssetsLibrary', 'CoreMedia'
  s.ios.libraries = 'c++', 'iconv', 'z'

end
