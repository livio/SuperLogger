Pod::Spec.new do |spec|
spec.name		= "SuperLogger"
spec.platform	= :ios, "6.0"
spec.version	= "0.0.2"
spec.license	= { :type => "New BSD", :file => 'LICENSE' }
spec.homepage	= https://github.com/livio/SuperLogger
spec.authors	= { 'Joel Fischer' => 'joel@livio.io' }
spec.summary	= "Advanced plugin-based Objective-C logging framework"
spec.source	= { :git => 'https://github.com/livio/SuperLogger.git', :tag => spec.version.to_s }

spec.subspec 'Core' do |cs|
cs.source_files = 'SuperLogger/*.{h,m}'
end

spec.subspec 'Console' do |cs|
cs.source_files = 'SuperLogger-Console/*.{h,m}'
cs.dependency = 'SuperLogger/Core'
end

spec.subspec 'File' do |fs|
fs.source_files = 'SuperLogger-File/*.{h,m}'
fs.dependency = 'SuperLogger/Core'
end

spec.subspec 'WebServer' do |wss|
wss.source_files	= 'SuperLogger-WebServer/*.{h,m}'
wss.dependency = 'SuperLogger/Core'
wss.dependency = 'livio/liviohttpserver'
end

spec.subspec 'ASL' do |asls|
asls.source_files = 'SuperLoggerASL/*.{h,m}'
asls.dependency = 'SuperLogger/Core'
end

spec.subspec 'NSLogger' do |nsl|
nsl.source_files = 'SuperLoggerNSLogger/*.{h,m}'
nsl.dependency = 'SuperLogger/Core'
nsl.dependency = 'NSLogger/NoStrip'
end

end