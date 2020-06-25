Pod::Spec.new do |s|
    s.name             = 'firebase_messaging_web'
    s.version          = '0.0.1'
    s.summary          = 'No-op implementation of flutter_facebook_login_web web plugin to avoid build issues on iOS'
    s.description      = <<-DESC
  temp fake flutter_facebook_login_web plugin
                         DESC
    s.homepage         = ''
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Niels Soeffers' => 'nsoeffers@gmail.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.dependency 'Flutter'

    s.ios.deployment_target = '8.0'
  end