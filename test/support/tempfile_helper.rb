module TempfileHelper

  # Create a temporary directory. This directory will exist for the life of
  # the spec.
  #
  # id - Identifier of the tmpdir (default: the default identifier).
  #
  # Returns a Pathname.
  def tmpdir(id=:default)
    @tmpdirs[id] ||= Pathname.new(Dir.mktmpdir).realdirpath
  end

  # Get a file within the tmpdir.
  def f(name)
    tmpdir + name
  end

  # Write a file within the tmpdir.
  def w(name, content)
    f(name).open("w") { |f| f.print content }
  end

  def self.included(base)
    base.class_eval do
      before do
        @tmpdirs = {}
      end
      after do
        @tmpdirs.values.each { |dir| FileUtils.rm_rf dir.to_s }
      end
    end
  end

end
