
module ProcessUtils
  def write_pid_file( file )
    File.open( file, "w" ) { |f| f.write( Process.pid ) }
    File.chmod( 0644, file )
  end
end