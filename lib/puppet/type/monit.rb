Puppet::Type.newtype(:monit) do
  ensurable
  @doc = "Monitor packages through Monit"
    newparam(:name) do
      desc "The name of the  package monitored under monit"
    end

    newparam(:pid_name) do
      desc "The pid file for the process i.e. /var/run/httpd/httpd.pid"
      defaultto "" 
      validate do |value|
        if not value.is_a? String or value.empty?
          raise ArgumentError,
            "pid_name is not a valid string!"
        else
          super
        end
      end
    end

    newparam(:process_timeout) do
      desc "timeout setting for a process execution"
      defaultto 20
      validate do |value|
        if not value.to_i.is_a? Numeric 
          raise ArgumentError,
            "process_timeout is not a number!"
        else
         super
      end
    end
  end

  autorequire(:service) do
    'monit'
  end
  
  autorequire(:package) do
    'monit'
  end
end
