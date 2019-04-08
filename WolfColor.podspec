Pod::Spec.new do |s|
    s.name             = 'WolfColor'
    s.version          = '4.0.1'
    s.summary          = 'A pure-Swift `Color` type (RGBA) and a library of conveniences for working with UIColor, CGColor, NSColor, blends, and gradients.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/wolfmcnally/WolfColor'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfColor.git', :tag => s.version.to_s }

    s.source_files = 'Sources/WolfColor/**/*'

    s.swift_version = '5.0'

    s.ios.deployment_target = '9.3'
    s.macos.deployment_target = '10.13'
    s.tvos.deployment_target = '11.0'

    s.module_name = 'WolfColor'

    s.dependency 'WolfCore'
end
