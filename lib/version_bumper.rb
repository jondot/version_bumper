require 'rake'
require 'bumper/version'

@vfile = 'VERSION'

def bumper_file(file)
  @vfile = file
end

def bumper_version
  @version ||= Bumper::Version.new(File.read(@vfile))
end


namespace :bump do
  desc "create a blank version file"
  task :init do
    @version =  Bumper::Version.new('0.0.0.0')
    @version.write(@vfile)    
  end
  
  desc "bump major"
  task :major do
    bumper_version.bump_major
    persist!
  end

  desc "bump minor"
  task :minor do
    bumper_version.bump_minor
    persist!
  end
  
  desc "bump patch[tag]"
  task :patch [:tag] do
    if tag.nil?
      bumper_version.bump_patch
    else
      bumper_version.bump_patch_tag
    end
    persist!
  end

  desc "bump build"
  task :build do
    bumper_version.bump_build
    persist!
  end
  
  def persist! 
    bumper_version.write(@vfile)    
    puts "version: #{bumper_version}"
  end
  
  # @deprecated Use :patch
  desc "bump revision"
  task :revision do
    bumper_version.bump_patch
    persist!
  end

end
