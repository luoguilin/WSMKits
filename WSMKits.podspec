
Pod::Spec.new do |s|

  s.name         = "WSMKits"
  s.version      = "0.0.2"
  s.summary      = "WSMKits is at development kits that the Mvoicer's developers using in projects. This kits includes PagedFlowView and so on."
  s.homepage     = "https://github.com/luoguilin/WSMKits"
  s.license      = "MIT"
  s.author       = { "Mvoicer Co., Ltd" => "mvoicer.com" }
  s.social_media_url = "https://weibo.com/mvoicer"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/m-voicer/WSMKits.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

end
