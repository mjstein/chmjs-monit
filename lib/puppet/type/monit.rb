Puppet::Type.newtype(:monit) do
ensurable
@doc = "Monitor packages through Monit"
  newparam(:name) do
    desc "The name of the  package monitored under monit"
  end
  newparam(:pidname) do
    desc "The pid file for the process i.e. /var/run/httpd/httpd.pid"
  end
  newparam(:process_timeout) do
    desc "timeout setting for a process execution"
    defaultto 20
    validate do |value|
      puts value
      if not value.is_a? Numeric 
        raise ArgumentError,
          "process_timeout is not a number!"
      else
       super
    end
  end
end
end
