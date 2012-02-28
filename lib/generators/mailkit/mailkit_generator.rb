class MailkitGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def copy_initializer
    template 'mailkit.rb', File.join('config', 'initializers', 'mailkit.rb')
  end
end