module Bumper
  class Version
    
    [:major, :minor, :patch, :patch_tag, :build].each do |part|
      define_method part do 
        @v[part]
      end

      define_method "bump_#{part}" do
        bump(part)
      end
    end
    
    def initialize(v)
      @v = {}
      if v =~ /^(\d+)\.(\d+)\.(\d+(|-[\dA-Za-z]+))(?:\.(.*?))?$/
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
        @v[:patch]    = $3.to_i
        @v[:patch_tag]= $4.to_s
        @v[:build]    = $5
      end
    end
    
    def bump(part)
      # patch tags go from alpha, alpha2, alpha3, etc.
      if part == :patch_tag
        t = @v[part]
        if t !~ %r{\d$}
          t += '1'
        end
        version = @v[part] = t.succ
      else
        version = @v[part] = @v[part].succ
      end
      
      return version if part == :build
      @v[:build] = '0' if @v[:build]
      return version if part == :patch_tag
      @v[:patch_tag] = ''
      return version if part == :patch
      @v[:patch] = 0
      return version if part == :minor
      @v[:minor] = 0

      version
    end
    
    def to_s
      [major, minor, (patch_tag.empty?? patch : [patch, patch-tag].join('-')), build].compact.join('.')
    end

    def write(f)
      File.open(f,'w'){ |h| h.write(self.to_s) }      
    end
  end
end
