require 'fileutils'

File.open('hathitable.org', 'r') do |f|
  while line = f.gets
    rec = line.split('|').map(&:strip)
    #bmtnid,make,model,creator,date = line.split('|').map(&:strip)
    bmtnid = rec[1]
    make   = rec[2]
    model  = rec[3]
    creator= rec[4]
    date   = rec[5]
    dir = FileUtils::mkdir_p "thunks/" + bmtnid
     fname = File.join(dir, 'meta.yml')
     File.open(fname, 'w') do |file|
       file.puts 'capture_date: ' + date
       file.puts 'capture_agent: NjP'
       file.puts 'scanner_user: Princeton University Library Digital Initiatives'
       file.puts 'scanner_make: ' + make
       file.puts 'scanner_model: ' + model
     end
  end
end
