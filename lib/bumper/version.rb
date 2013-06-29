module Bumper
  class Version
    
    [:major, :minor, :patch, :build].each do |part|
      define_method part do
        @v[part]
      end

      define_method "#{part}=" do |arg|
        puts "method #{part}= set #{part} to #{arg}"
        @v[part] = arg
      end

      define_method "bump_#{part}" do
        bump(part)
      end
    end
    

    def initialize(v = '0.0.0.0')
      @v = {}
      if v =~ /^(\d+)\.(\d+)$/ # 0.0
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
      elsif v =~ /^(\d+)\.(\d+)\.(\d+)$/ # 0.0.0
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
        @v[:patch]    = $3.to_i
      elsif v =~ /^(\d+)\.(\d+)\.(\d+)-([A-Za-z\d]+)$/ # 0.0.0-alpha
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
        @v[:patch]    = $3.to_i
        @v[:patch_tag]= $4.empty?? nil : $4.to_s
      elsif v =~ /^(\d+)\.(\d+)\.(\d+)\.([A-Za-z\d]+)$/ # 0.0.0.0
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
        @v[:patch]    = $3.to_i
        @v[:build]    = $4.to_s
      elsif v =~ /^(\d+)\.(\d+)\.(\d+)-([A-Za-z\d]+)\.([A-Za-z\d]+)$/ # 0.0.0-alpha.0
        @v[:major]    = $1.to_i
        @v[:minor]    = $2.to_i
        @v[:patch]    = $3.to_i
        @v[:patch_tag]= $4.empty?? nil : $4.to_s
        @v[:build]    = $5.to_s
      else
        raise ArgumentError, "Invalid version format (MAJOR.MINOR[.PATCH[-TAG[.BUILD]]]): #{v}"
      end
    end
    
    def patch_tag
      @v[:patch_tag]
    end

    def patch_tag= tag
      @v[:patch_tag] = (tag.nil? or tag.empty? ? nil : tag.to_s)
    end
    
    # patch tags go from alpha, alpha2, alpha3, etc.
    def bump_patch_tag tag
      @v[:build] = '0' unless build.nil?
      if patch_tag.nil?
        @v[:patch] = patch.succ
        return @v[:patch_tag] = tag
      elsif patch_tag.start_with? tag
        # ensure tag ends with number
        if patch_tag !~ %r{\d$}
          @v[:patch_tag] = patch_tag + '1' # required for succ to work
        end
        # increment this tag
        @v[:patch_tag] = patch_tag.succ
      else
        @v[:patch_tag] = tag # replace tag
      end
    end
    
    def bump(part)
      return (@v[part] = (build.nil?? '1' : build.succ)) if part == :build
      @v[:build] = '0' unless build.nil?
      if part == :patch and not @v[:patch_tag].nil?
        @v[:patch_tag] = nil # just drop the tag
        return patch
      end
      @v[:patch_tag] = nil
      return (@v[part] = patch.succ) if part == :patch
      @v[:patch] = 0
      return (@v[part] = minor.succ) if part == :minor
      @v[:minor] = 0
      return (@v[part] = major.succ)
    end
    
    def to_s
      if patch.nil?
        [major, minor]
      else
        if patch_tag.nil?
          [major, minor, patch, build]
        else
          [major, minor, [patch, patch_tag].join('-'), build]
        end
      end.select {|x| not x.nil?}.join('.')
    end

    def write(f)
      File.open(f,'w'){ |h| h.write(self.to_s) }      
    end
    
    # @deprecated Use patch
    def revision
      patch
    end
    
    # @deprecated Use bump_patch
    def bump_revision
      bump_patch
    end
    
  end
end
