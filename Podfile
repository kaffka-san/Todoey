# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'Todoey' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
  post_install do |installer|
          installer.pods_project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
              end
          end
      end
  # Pods for Todoey

end
