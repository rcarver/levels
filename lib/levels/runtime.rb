module Levels
  # Public: Methods in this module are available within any Ruby input.
  # You may extend it with any additonal methods you require.
  module Runtime

    FileNotFoundError = Class.new(RuntimeError)

    # Public: Read the value from a file on disk. The file
    # will not be read until the key is accessed.
    #
    # file_path - String path to the file. The path may be absolute,
    #             or relative to the Ruby file calling this function.
    #           
    # Returns a Proc that reads the file when called.
    # That proc raises Levels::Ruby::FileNotFoundError if the file does
    #   not exist.
    def file(file_path)
      return nil if file_path.nil?
      caller_path = Pathname.new(caller[0]).dirname
      -> do
        path = caller_path + file_path
        if path.exist?
          path.read
        else
          raise FileNotFoundError, path.to_s
        end
      end
    end
  end
end
