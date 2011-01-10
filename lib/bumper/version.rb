module Bumper
  class Version
    
    [:major, :minor, :revision, :build].each do |part|
      define_method part do 
        @v[part]
      end

      define_method "bump_#{part}" do
        bump(part)
      end
    end
    
    def initialize(v)
      @v = {}
      if v =~ /^(\d+)\.(\d+)\.(\d+)(?:\.(.*?))?$/
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
        @v[:revision] = $3.to_i
        @v[:build]    = $4
      end
    end
    
    def bump(part)
      @v[part] = @v[part].succ
      
      return @v[part] if part == :build
      @v[:build] = '0'
      return @v[part] if part == :revision
      @v[:revision] = 0
      return @v[part] if part == :minor
      @v[:minor] = 0
      @v[part]
    end
    
    def to_s
      [major, minor, patch, build].compact.join('.')
    end

    def write(f)
      File.open(f,'w'){ |h| h.write(self.to_s) }      
    end
  end
end
