VersionFilePath = "#{::Rails.root.to_s}/VERSION"

Themis::Application.config.send "version_name=", if FileTest.exists?(VersionFilePath) then
  IO.read(VersionFilePath)
else
  "development"
end
