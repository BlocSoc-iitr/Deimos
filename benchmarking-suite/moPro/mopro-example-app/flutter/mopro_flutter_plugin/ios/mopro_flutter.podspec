#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mopro_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'mopro_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.vendored_frameworks = 'MoproBindings.xcframework'
  s.preserve_paths = 'MoproBindings.xcframework/**/*'
  
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Dynamically determine which architectures to exclude based on xcframework availability
  xcframework_path = File.join(File.dirname(__FILE__), 'MoproBindings.xcframework')
  info_plist_path = File.join(xcframework_path, 'Info.plist')
  
  excluded_config = {}
  
  if File.exist?(info_plist_path)
    begin
      content = File.read(info_plist_path)
      simulator_archs = []
      device_archs = []
      
      # Simple XML parsing to extract architectures
      current_lib = nil
      in_supported_archs = false
      is_simulator = false
      
      content.each_line do |line|
        line = line.strip
        
        # Detect library blocks
        if line.include?('<key>LibraryIdentifier</key>')
          current_lib = :new_lib
          is_simulator = false
        elsif current_lib == :new_lib && line.include?('<string>') && line.include?('simulator')
          is_simulator = true
        elsif line.include?('<key>SupportedArchitectures</key>')
          in_supported_archs = true
        elsif in_supported_archs && line.include?('</array>')
          in_supported_archs = false
          current_lib = nil
        elsif in_supported_archs && line.include?('<string>') && line.include?('</string>')
          # Extract architecture name
          arch = line.gsub(/<\/?string>/, '').strip
          if is_simulator
            simulator_archs << arch
          else
            device_archs << arch
          end
        end
      end
      
      # All possible architectures
      all_simulator_archs = ['x86_64', 'arm64']
      all_device_archs = ['arm64', 'armv7']
      
      # Exclude unsupported simulator architectures
      excluded_simulator = all_simulator_archs - simulator_archs.uniq
      if !excluded_simulator.empty?
        excluded_config['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = excluded_simulator.join(' ')
      end
      
      # Exclude unsupported device architectures  
      excluded_device = all_device_archs - device_archs.uniq
      if !excluded_device.empty?
        excluded_config['EXCLUDED_ARCHS[sdk=iphoneos*]'] = excluded_device.join(' ')
      end
      
    rescue => e
      puts "Warning: Could not parse xcframework Info.plist: #{e.message}"
      # Fallback to safe defaults - exclude x86_64 only if we can't parse
      excluded_config['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
    end
  else
    puts "Warning: xcframework Info.plist not found, using safe defaults"
    # Fallback to safe defaults
    excluded_config['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
  end
  
  # Build the pod_target_xcconfig with dynamic exclusions
  base_config = { 'DEFINES_MODULE' => 'YES' }
  final_config = base_config.merge(excluded_config)

  s.pod_target_xcconfig = final_config
  s.swift_version = '5.0'
end
