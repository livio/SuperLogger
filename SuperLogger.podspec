Pod::Spec.new do |spec|
  spec.name		= "SuperLogger"
  spec.platform	= :ios, "7.0"
  spec.version	= "0.1.0"
  spec.license	= { :type => "New BSD", :file => 'LICENSE' }
  spec.homepage	= https://github.com/livio/SuperLogger
  spec.authors	= { 'Joel Fischer' => 'joel@livio.io' }
  spec.summary	= "Advanced plugin-based Objective-C logging framework"
  spec.source	= { :git => 'https://github.com/livio/SuperLogger.git', :tag => spec.version.to_s }
  
  spec.subspec 'Core' do |cs|
    cs.source_files	= 'SuperLogger/*.{h,m}'
  end

  spec.subspec 'Console' do |cs|
    cs.source_files	= 'SuperLogger-Console/*.{h,m}'
  end

  spec.subspec 'CoreData' do |cds|
    cds.source_files	= 'SuperLogger-CoreData/*.{h,m}'
  end

  spec.subspec 'File' do |fs|
    fs.source_files	= 'SuperLogger-File/*.{h,m}'
  end

  spec.subspec 'WebServer' do |wss|
    wss.source_files	= 'SuperLogger-WebServer/*.{h,m}'
  end

end