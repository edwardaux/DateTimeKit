Pod::Spec.new do |s|
  s.name         = "DateTimeKit"
  s.version      = "1.0.0"
  s.summary      = "DateTimeKit is a Swift library that provides simple, easy-to-use date, time and timezone manipulation."

  s.description  = <<-DESC
							DateTimeKit is a Swift library that provides simple, easy-to-use date, time and timezone manipulation.
							The ideas behind DateTimeKit are quite heavily influenced by the JodaTime library.

							DateTimeKit removes the dependence on NSDate and NSCalendar and provides a new set of objects in their
							place.
                   DESC

  s.homepage     = "https://github.com/edwardaux/DateTimeKit"
  s.license      = { :type => "MIT" }
  s.authors      = { 'Daniele Margutti' => 'me@danielemargutti.com', 'Craig Edwards' => 'edwardaux', 'Zacharias Beckman' => 'zbeckman@HyraxLLC.com' }
  s.source       = { :git => "https://github.com/edwardaux/DateTimeKit.git", :tag => '1.0.0' }
  s.source_files = "DateTimeKit", "DateTimeKit/**/*.{swift,h,m}"
  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
end
