require 'rake'
require 'rake/packagetask'
require 'yaml'

ROOT_DIR = File.expand_path(File.dirname(__FILE__))
SRC_DIR = File.join(ROOT_DIR, 'src')
DIST_DIR = File.join(ROOT_DIR,'dist')

RELEASE_DIR = File.join(DIST_DIR, 'release')

TEST_DIR      = File.join(ROOT_DIR, 'test')
TEST_UNIT_DIR = File.join(TEST_DIR, 'unit')
TMP_DIR       = File.join(TEST_UNIT_DIR, 'tmp')

$:.unshift File.join(ROOT_DIR, 'vendor', 'sprockets', 'lib')

def sprocketize(path, source, destination=nil)
  destination ||= [*source].first
  begin
    require "sprockets"
  rescue LoadError => e
    puts "\nzebedee requires Sprockets to build the files. Just run:\n\n"
    puts "  $ git submodule init"
    puts "  $ git submodule update"
    puts "\nto pull in the necessary submodules.\n\n"
  end
  
  puts "Sprocketizing (#{[*source].join(', ')})..."
  secretary = Sprockets::Secretary.new(
    :root         => File.join(ROOT_DIR, path),
    :load_path    => [SRC_DIR],
    :source_files => [*source]
  )
  
  secretary.concatenation.save_to(File.join(DIST_DIR, destination))
end

task :default => [:clean, :dist]

desc "Clean the distribution directory."
task :clean do 
  rm_rf DIST_DIR
  mkdir DIST_DIR
  mkdir RELEASE_DIR
end

def dist_from_sources(source)
 
  sprocketize("src", source)
   
end

desc "Generates a minified version for distribution, using UglifyJS."
task :dist do
  cp File.join(SRC_DIR,'obscura.js'), File.join(DIST_DIR,'obscura.js')
  src, target = File.join(DIST_DIR,'obscura.js'), File.join(RELEASE_DIR,'obscura.min.js')
  uglifyjs src, target
  process_minified src, target
end

def uglifyjs(src, target)
  begin
    require 'uglifier'
  rescue LoadError => e
    if verbose
      puts "\nYou'll need the 'uglifier' gem for minification. Just run:\n\n"
      puts "  $ gem install uglifier"
      puts "\nand you should be all set.\n\n"
      exit
    end
    return false
  end
  puts "Minifying #{src} with UglifyJS..."
  File.open(target, "w"){|f| f.puts Uglifier.new.compile(File.read(src))}
end

def process_minified(src, target)
  cp target, File.join(DIST_DIR,'temp.js')
  msize = File.size(File.join(DIST_DIR,'temp.js'))
  `gzip -9 #{File.join(DIST_DIR,'temp.js')}`

  osize = File.size(src)
  dsize = File.size(File.join(DIST_DIR,'temp.js.gz'))
  rm_rf File.join(DIST_DIR,'temp.js.gz')

  puts "Original version: %.3fk" % (osize/1024.0)
  puts "Minified: %.3fk" % (msize/1024.0)
  puts "Minified and gzipped: %.3fk, compression factor %.3f" % [dsize/1024.0, osize/dsize.to_f]
end
