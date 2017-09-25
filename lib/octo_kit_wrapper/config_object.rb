
# configuration object for configuring the project
class Config

  def initialize(data = {})
    data.each { |k, v| send "#{k}=", v }
  end

  def method_missing(name, *args, &block)
    value = args[0]
    if name.match(/^.*=/) != nil
      unless respond_to?(name) || respond_to?(name.to_s.delete('=').to_sym)
        define_singleton_method(name) do |val|
          instance_variable_set("@#{name.to_s.delete('=')}", val)
        end
        define_singleton_method(name.to_s.delete('=')) do
          instance_variable_get("@#{name.to_s.delete('=')}")
        end
        send(name, value)
      end
    else
      super
    end
  end

  # TODO: This is actually a bug, but I am lazy.
  def respond_to_missing?(*several_variants)
    super
  end

end

