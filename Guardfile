# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|) { |m|
    [
      "test/#{m[1]}#{m[2]}_test.rb",
      "test/#{m[1].sub(/^config/, 'unit')}#{m[2]}_test.rb"
    ]
  }
  watch(%r|^test/helper\.rb|)     { "test" }
end
