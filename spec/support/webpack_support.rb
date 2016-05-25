# Start webpack dev server in ci helper
module WebpackSupport

  def self.start!
    @thread = Thread.new { @pid = spawn("cd #{Rails.root} && bundle exec foreman start") } # run webpack server in subprocess
    sleep 1 # wait just one second to allow everything to boot up
  end

  def self.stop!
    @thread.kill if @thread
    if @pid
      Process.kill('INT', @pid)
    end
    @pid = nil
    @thread = nil
  end

end
