Puppet::Type.type(:monit).provide(:monit) do
  confine :osfamily => :redhat
  commands :monit => 'monit'

  def exists?
     status = check_if_process_exists
     return true if status == 'running'
     return false if status == 'not monitored'
     return create_monit_file
  end

  def create
    monit('start', resource[:name])
  end

  def destroy
    monit('stop', resource[:name])
  end

  def create_monit_file
    File.open("/etc/monit.d/#{resource[:name]}.monit.conf", "w"){ |f|
      f.write("check process httpd with pidfile /var/run/httpd/httpd.pid\n    start program = \"/etc/init.d/httpd start\" with timeout 60 seconds\n     stop program  = \"/etc/init.d/httpd stop\""
      )}
      monit('reload')
      status = ""
      while status == "" 
        status = check_if_process_exists 
      end
      return false
  end

  def check_if_process_exists
    status = ""
    results = monit('status')
    procs = results.split("\n\n")
    procs.each do |proc_info|
      lines = proc_info.split("\n")
      if lines[0].strip == "Process '#{resource[:name]}'"
        status = lines[1].split(" ")[1..-1].join(" ")
      end
    end
    return status
  end

end
