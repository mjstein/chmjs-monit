module Puppet::Parser::Functions
  newfunction(:get_package_names, :type => :rvalue) do |args|
    return package_names = args[0].keys
  end
end
