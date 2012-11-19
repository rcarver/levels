group :examples
  set file_name: nil
  set file_value1: file("02_value")
  set file_value2: -> { file(examples.file_name) }
