require "hijack_method/version"

module HijackMethod

  def hijack_method(method_name, options={})
    
    method_name = method_name.to_sym
    hijacked_method_name = :"___hijacked_#{method_name}" 
    
    return if instance_methods(false).include? hijacked_method_name 

    alias_method hijacked_method_name, method_name

    define_method(method_name) do |*args, &block|
      options[:before].call(*args, &block) unless options[:before].nil?
      ret_value = send(hijacked_method_name, *args, &block)
      options[:after].call(*args, &block) unless options[:after].nil?
      ret_value
    end
  end

end
