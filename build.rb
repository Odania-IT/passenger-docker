require 'optparse'
require 'json'

version_file_data = JSON.parse(File.read('version.json'))

options = {}
OptionParser.new do |opts|
	opts.banner = 'Usage: build.rb [options]'

	opts.on('-vVERSION', '--version=VERSION', 'Set the version to build') do |n|
		options[:version] = n
	end

	opts.on('-h', '--help', 'Prints this help') do
		puts opts
		exit
	end
end.parse!

version = options[:version]
if version.nil?
	version = version_file_data['version'].to_i + 1
else
	version = version.to_i
end

def runCommand(cmd)
	throw "Error in cmd: #{cmd}" unless system(cmd)
end

Dir.chdir('image')

p "Building version #{version}"
cmd = "docker build -t odania-it/passenger-docker:v#{version} ."
runCommand(cmd)

p "Tagging version #{version}"
cmd = "docker tag odania-it/passenger-docker:v#{version} odania-it/passenger-docker:v#{version}"
runCommand(cmd)
cmd = "docker tag -f odania-it/passenger-docker:v#{version} odania-it/passenger-docker:latest"
runCommand(cmd)

p "Pushing version #{version}"
cmd = 'docker push odania-it/passenger-docker'
runCommand(cmd)

p 'Updating version file'
version_file_data['version'] = version
File.open('version.json', 'w') do |f|
	f.write(JSON.pretty_generate(version_file_data))
end

Dir.chdir('..')

p 'Finished'
