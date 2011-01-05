module Bumper
  class Version
    
    ['major', 'minor', 'revision', 'build'].each do |part|
      define_method part do 
        @v[part]
      end
    end
    
    def initialize(v)
      @v= {}
      if v =~ /^(\d+)\.(\d+)\.(\d+)(?:\.(.*?))?$/
          @v['major'] = $1.to_i
          @v['minor'] = $2.to_i
          @v['revision'] = $3.to_i
          @v['build'] = $4
      end
    end
    
    def bump(part)
      @v[part] = @v[part].succ
      
      return @v[part] if part == 'build'      
      @v['build'] = '0'
      return @v[part] if part == 'revision'
      @v['revision'] = 0
      return @v[part] if part == 'minor'
      @v['minor'] = 0
      @v[part]
    end
    
    def method_missing(m, *args, &block)
      if(m.to_s =~ /^bump_(.*)$/)
        if @v.has_key? $1
          return send(:bump, $1)
        end
      end
      super
    end
    
    def to_s
      "#{major}.#{minor}.#{revision}" + (build.nil? ? "" : ".#{build}")
    end
    def write(f)
      File.open(f,'w'){ |h| h.write(self.to_s) }      
    end
  end
end
