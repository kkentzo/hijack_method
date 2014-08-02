require "hijack_method/version"

module HijackMethod

  class Hijacker < Struct.new(:object)

    def hijack(method_name, options={})

      method_name = method_name.to_sym
      hijacked_method_name = generate_name(method_name)

      return if object.instance_methods(false).include? hijacked_method_name 

      object.send(:alias_method, hijacked_method_name, method_name)
      new_method = Proc.new do |*args, &block|
        options[:before].call(*args, &block) unless options[:before].nil?
        ret_value = options[:main].nil? ? 
          send(hijacked_method_name, *args, &block) :
          options[:main].call(*args, &block)
        options[:after].call(*args, &block) unless options[:after].nil?
        ret_value
      end
      object.send(:define_method, method_name, new_method)
    end

    private
    
    def generate_name(method_name)
      :"___hijacked_#{method_name}"
    end
  end

  def hijack_method(method_name, options={})
    Hijacker.new(self).hijack(method_name, options)
  end

end
