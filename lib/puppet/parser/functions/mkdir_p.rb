module Puppet::Parser::Functions
  newfunction(:mkdir_p) do |args|
    Puppet::Parser::Functions.function(:ensure_resource)

    directory, params = args

    directory_names = directory.split(/\//).delete_if(&:empty?)
    paths = directory_names.inject([]) do |directories, directory_name|
      directories << File.join(directories.last || '/', directory_name)
    end

    paths.each do |path|
      function_ensure_resource(['file', path, params])
    end
  end
end
